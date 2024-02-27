import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/extensions/build_context.dart';
import '../../../core/extensions/color.dart';
import '../../constants/gen/assets.gen.dart';
import '../../themes/app_color.dart';
import 'pages/activity/activity_page.dart';
import 'pages/home/home_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/search/search_page.dart';
import 'widgets/menu_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  ValueNotifier<int> currentPage = ValueNotifier(0);
  ValueNotifier<bool> isMenuOpen = ValueNotifier(false);

  late AnimationController _animationController;
  late PageController _pageController;
  late Animation<double> movingAnimation;
  late Animation<double> scaleAnimation;
  late double menuSize;
  late double bottomNavSize;
  late List<(String iconFill, String iconOutline)> navIcons;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();

    navIcons = [
      (Assets.icons.homeFill, Assets.icons.homeOutline),
      (Assets.icons.searchFill, Assets.icons.searchOutline),
      (Assets.icons.bookFill, Assets.icons.bookOutline),
      (Assets.icons.profileFill, Assets.icons.profileOutline),
    ];

    _pageController = PageController();
    pages = [
      const HomePage(key: PageStorageKey("HomePage")),
      const SearchPage(key: PageStorageKey("SearchPage")),
      const ActivityPage(key: PageStorageKey("ActivityPage")),
      const ProfilePage(key: PageStorageKey("ProfilePage")),
    ];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    movingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapNavigateToPage(int index) {
    currentPage.value = index;
    _pageController.jumpToPage(index);
  }

  void _onSwipeScreen(DragUpdateDetails details) {
    if (!isMenuOpen.value && details.delta.dx > 0) {
      _animationController.forward();
      isMenuOpen.value = true;
    }
    if (isMenuOpen.value && details.delta.dx < 0) {
      _animationController.reverse();
      isMenuOpen.value = false;
    }
  }

  void _onMenuDrawer() {
    if (isMenuOpen.value) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    isMenuOpen.value = false;
    currentPage.value = 0;
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    menuSize = context.screenWidth * 0.65;
    bottomNavSize = 52.h;

    return AnimatedBuilder(
      animation: _animationController,
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) => currentPage.value = i,
        children: pages,
      ),
      builder: (_, animatedChild) {
        return PopScope(
          canPop: false,
          child: GestureDetector(
            onPanUpdate: _onSwipeScreen,
            child: Scaffold(
              backgroundColor: context.colors.blue900.darken(
                context.isDarkTheme ? 0.05 : 0,
              ),
              body: ValueListenableBuilder<bool>(
                valueListenable: isMenuOpen,
                child: animatedChild,
                builder: (context, menuOpen, child) {
                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                        width: menuSize,
                        left: menuOpen ? 0 : -menuSize,
                        height: context.screenHeight,
                        child: MenuDrawer(
                          onClosed: _onMenuDrawer,
                        ),
                      ),
                      Transform(
                        transform: Matrix4.identity(),
                        child: Transform.translate(
                          offset: Offset(movingAnimation.value * menuSize, 0),
                          child: Transform.scale(
                            scale: scaleAnimation.value,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                menuOpen ? 25.r : 0.0,
                              ),
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              extendBody: true,
              bottomNavigationBar: _buildBottomNavigationBar(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Transform.translate(
      offset: Offset(0, bottomNavSize * 1.5 * movingAnimation.value),
      child: SafeArea(
        child: Container(
          height: bottomNavSize,
          padding: EdgeInsets.symmetric(
            vertical: 10.h / 2,
            horizontal: 10.w * 1.25,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 12.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.theme.scaffoldBackgroundColor,
                context.theme.scaffoldBackgroundColor.darken(.025),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: context.colors.grey800.withOpacity(.05),
              )
            ],
            border: Border.all(
              color: context.colors.grey400.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: navIcons
                .mapIndexed(
                  (index, icons) => Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onTapNavigateToPage(index),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        height: 50.h,
                        width: bottomNavSize,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ValueListenableBuilder<int>(
                          valueListenable: currentPage,
                          builder: (context, pageIndex, _) {
                            return SvgPicture.asset(
                              pageIndex == index ? icons.$1 : icons.$2,
                              height: 25,
                              width: 25,
                              colorFilter: ColorFilter.mode(
                                pageIndex == index
                                    ? context.colors.blue
                                    : context.colors.grey600,
                                BlendMode.srcIn,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
