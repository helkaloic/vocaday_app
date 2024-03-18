import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/managers/navigation.dart';
import '../../../../../../app/managers/shared_preferences.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../word/domain/entities/word_entity.dart';
import '../../../../../word/domain/usecases/get_all_words.dart';
import '../../../domain/usecases/remove_all_known_word.dart';
import '../../../domain/usecases/sync_known_word.dart';

part 'known_word_state.dart';

class KnownWordCubit extends Cubit<KnownWordState> {
  final GetAllWordsUsecase getAllWordsUsecase;
  final RemoveAllKnownWordUsecase removeAllKnownWordUsecase;
  final SyncKnownWordUsecase syncKnownWordUsecase;
  final SharedPrefManager sharedPrefManager;
  KnownWordCubit(
    this.getAllWordsUsecase,
    this.removeAllKnownWordUsecase,
    this.syncKnownWordUsecase,
    this.sharedPrefManager,
  ) : super(const KnownWordEmptyState());

  Future<void> syncKnowns(String uid) async {
    emit(const KnownWordLoadingState());

    final wordEither = await getAllWordsUsecase();

    wordEither.fold(
      (failure) => emit(KnownWordErrorState(failure.message)),
      (wordList) async {
        final knownList = sharedPrefManager.getKnownWords;
        final result = await syncKnownWordUsecase((uid, knownList));

        result.fold(
          (failure) => emit(KnownWordErrorState(failure.message)),
          (newKnowns) async {
            Set<WordEntity> knowns = {};

            //? Merge data from database
            for (String element in newKnowns) {
              final word = wordList.firstWhere((e) => e.word == element);
              knowns.add(word);
            }

            //? Save to local
            await sharedPrefManager.saveKnownWord(newKnowns);

            Navigators().showMessage(
              LocaleKeys.known_sync_data_success.tr(),
              type: MessageType.success,
            );
            emit(
              KnownWordLoadedState(knowns.toList().reversed.toList()),
            );
          },
        );
      },
    );
  }

  Future<void> removeAllKnowns(String uid) async {
    emit(const KnownWordLoadingState());
    sharedPrefManager.clearAllFavouriteWords();

    final result = await removeAllKnownWordUsecase(uid);
    result.fold(
      (failure) => emit(KnownWordErrorState(failure.message)),
      (_) => emit(const KnownWordLoadedState([])),
    );
  }

  Future<void> getAllKnownWords() async {
    emit(const KnownWordLoadingState());

    final wordEither = await getAllWordsUsecase();

    wordEither.fold(
      (failure) => emit(KnownWordErrorState(failure.message)),
      (wordList) {
        List<WordEntity> knowns = [];
        final local = sharedPrefManager.getKnownWords;

        for (String element in local) {
          final word = wordList.firstWhere((e) => e.word == element);
          knowns.add(word);
        }

        emit(KnownWordLoadedState(knowns.reversed.toList()));
      },
    );
  }
}
