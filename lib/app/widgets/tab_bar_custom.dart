import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../constants/app_element.dart';
import '../themes/app_color.dart';
import '../themes/app_text_theme.dart';

class TabBarCustom extends StatelessWidget {
  const TabBarCustom({super.key, required this.tabs});
  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppElement.tabBarSize.h,
      width: context.screenWidth,
      padding: EdgeInsets.all(5.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: context.isDarkTheme
            ? context.colors.grey900
            : context.colors.grey150,
        // border: Border.all(color: context.colors.grey300.withOpacity(0.15)),
      ),
      child: TabBar(
        labelStyle: context.textStyle.bodyS.bold.bw,
        unselectedLabelStyle: context.textStyle.bodyS.grey,
        indicatorWeight: 0,
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(7.r),
          color: context.theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: context.isDarkTheme
                  ? context.colors.grey900
                  : context.colors.grey200,
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        tabs: tabs,
      ),
    );
  }
}
