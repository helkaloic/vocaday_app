import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/constants/gen/assets.gen.dart';
import '../../../../app/managers/navigation.dart';
import '../../../../app/managers/shared_preferences.dart';
import '../../../../app/themes/app_text_theme.dart';
import '../../../../app/translations/translations.dart';
import '../../../../app/widgets/app_bar.dart';
import '../../../../app/widgets/error_page.dart';
import '../../../../app/widgets/list_tile_custom.dart';
import '../../../../app/widgets/loading_indicator.dart';
import '../../../../app/widgets/text.dart';
import '../../../../core/extensions/build_context.dart';
import '../../../../injection_container.dart';
import '../../../authentication/presentation/blocs/auth/auth_bloc.dart';
import '../../../word/domain/entities/word_entity.dart';
import '../../../word/domain/usecases/get_all_words.dart';
import '../../../word/presentation/pages/word_detail_bottom_sheet.dart';
import '../../domain/usecases/update_favourite_word_usecase.dart';
import '../cubit/word_favourite_cubit.dart';
import '../widgets/search_favourite_word_widget.dart';

enum FavouriteMenu { sync, clearAll }

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final ValueNotifier<List<WordEntity>> favourteNotifer = ValueNotifier([]);

  Future<void> _onRefresh(
    BuildContext context, {
    Duration delay = Durations.long2,
  }) async {
    Navigators().showLoading(
      tasks: [
        context.read<WordFavouriteCubit>().getAllFavouriteWords(),
      ],
      delay: delay,
    );
  }

  void _onOpenWordDetail(BuildContext context, WordEntity entity) {
    context.showBottomSheet(
      child: WordDetailBottomSheet(wordEntity: entity),
    );
  }

  Future<void> _onSearch(BuildContext context, String input) async {
    if (input.isNotEmpty) {
      favourteNotifer.value = favourteNotifer.value
          .where((e) => e.word.toLowerCase().contains(input))
          .toList();
    } else {
      await context.read<WordFavouriteCubit>().getAllFavouriteWords();
    }
  }

  Future<void> _onRemoveItem(String word) async {
    await Navigators().showLoading(tasks: [
      sl<SharedPrefManager>().removeFavouriteWord(word),
    ], delay: Durations.medium2);
    favourteNotifer.value = List<WordEntity>.from(favourteNotifer.value)
      ..removeWhere((e) => e.word == word);
  }

  Future<void> _onClearAll(BuildContext context) async {
    Navigators().showDialogWithButton(
      title: LocaleKeys.favourite_clear_all_fav_title.tr(),
      subtitle: LocaleKeys.favourite_clear_all_favourites.tr(),
      acceptText: LocaleKeys.common_accept.tr(),
      onAccept: () async {
        sl<SharedPrefManager>().clearAllFavouriteWords();
        await context.read<WordFavouriteCubit>().getAllFavouriteWords();
        favourteNotifer.value = [];
      },
    );
  }

  Future<void> _onSyncData(BuildContext context) async {
    final uid = context.read<AuthBloc>().state.user?.uid;
    if (uid != null) {
      await context.read<WordFavouriteCubit>().updateFavourites(uid);
    }
  }

  void _onSelectMenu(FavouriteMenu item, BuildContext context) {
    switch (item) {
      case FavouriteMenu.sync:
        _onSyncData(context);
        break;
      case FavouriteMenu.clearAll:
        _onClearAll(context);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WordFavouriteCubit(
        sl<GetAllWordsUsecase>(),
        sl<UpdateFavouriteWordUsecase>(),
      )..getAllFavouriteWords(),
      lazy: false,
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: AppBarCustom(
            leading: const BackButton(),
            textTitle: LocaleKeys.favourite_favourites.tr(),
            action: _buildPopupMenu(context),
          ),
          body: BlocBuilder<WordFavouriteCubit, WordFavouriteState>(
            builder: (context, state) {
              if (state is WordFavouriteLoadingState) {
                return const LoadingIndicatorPage();
              }
              if (state is WordFavouriteErrorState) {
                return ErrorPage(text: state.message);
              }
              if (state is WordFavouriteLoadedState) {
                favourteNotifer.value = state.words;
                return RefreshIndicator(
                  onRefresh: () async => _onRefresh(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50.h,
                        width: context.screenWidth,
                        margin: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 15.w,
                        ).copyWith(top: 15.h),
                        child: SearchFavouriteWordWidget(
                          onSearch: (value) => _onSearch(context, value),
                        ),
                      ),
                      Expanded(
                        child: _buildFavourites(),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        );
      }),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
      surfaceTintColor: context.theme.cardColor,
      onSelected: (val) => _onSelectMenu(val, context),
      itemBuilder: (context) => [
        _buildMenuItem(
          context: context,
          icon: Icons.cloud_sync_outlined,
          text: LocaleKeys.favourite_sync_data.tr(),
          value: FavouriteMenu.sync,
        ),
        _buildMenuItem(
          context: context,
          icon: Icons.remove_done_outlined,
          text: LocaleKeys.favourite_clear_all.tr(),
          value: FavouriteMenu.clearAll,
        ),
      ],
    );
  }

  PopupMenuItem<FavouriteMenu> _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required FavouriteMenu value,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Icon(
              icon,
              color: context.theme.primaryColor,
            ),
          ),
          TextCustom(
            text,
            style: context.textStyle.bodyS.bw,
          ),
        ],
      ),
    );
  }

  Widget _buildFavourites() {
    return ValueListenableBuilder(
      valueListenable: favourteNotifer,
      builder: (context, favourites, _) {
        if (favourites.isEmpty) {
          return ErrorPage(
            text: LocaleKeys.search_not_found.tr(),
            image: Assets.jsons.notFoundDog,
          );
        }
        return ListView.builder(
          itemCount: favourites.length,
          // physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w),
              child: Material(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(8.r),
                shadowColor: context.shadowColor.withOpacity(.5),
                elevation: 1.5,
                child: InkWell(
                  onTap: () => _onOpenWordDetail(context, favourites[index]),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 15.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ListTileCustom(
                      title: TextCustom(favourites[index].word.toLowerCase()),
                      trailing: GestureDetector(
                        onTap: () => _onRemoveItem(favourites[index].word),
                        child: SvgPicture.asset(
                          Assets.icons.closeCircle,
                          colorFilter: ColorFilter.mode(
                            context.greyColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}