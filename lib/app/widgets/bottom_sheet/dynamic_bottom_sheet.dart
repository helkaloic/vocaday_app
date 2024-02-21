import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/build_context.dart';
import '../../../core/extensions/string.dart';
import '../../constants/app_element.dart';
import '../../themes/app_text_theme.dart';
import '../../translations/translations.dart';
import '../gap.dart';
import '../text.dart';
import '../unfocus.dart';

class DynamicBottomSheetCustom extends StatelessWidget {
  const DynamicBottomSheetCustom({
    super.key,
    required this.children,
    this.showDragHandle = false,
    this.backgroundColor,
    this.padding,
    this.textTitle,
    this.textAction,
    this.onAction,
  });

  /// Show drag handle. Best practice is only show if [textTitle] is `null`.
  final bool showDragHandle;

  /// Text in title of bottom sheet. If it sets to `null`, the bottom sheet
  /// title will be hidden.
  final String? textTitle;

  /// The body of bottom sheet. Excludes bottom sheet title.
  final List<Widget> children;

  /// Text for action button on the right.
  final String? textAction;

  /// Action button callback.
  final VoidCallback? onAction;

  /// Apply padding for bottom sheet title.
  final EdgeInsetsGeometry? padding;

  /// Color for background of bottom sheet, excludes title bar.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.bottomSheetBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: textTitle.isNotNullOrEmpty
                    ? AppElement.appBarHeight.h + 20.h
                    : 30.h),
            padding: padding,
            child: SingleChildScrollView(
              child: UnfocusArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            child: _buildTitle(context),
          )
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return textTitle.isNotNullOrEmpty
        ? _buildTitleBar(context)
        : showDragHandle
            ? Container(
                padding: EdgeInsets.only(top: 5.h),
                child: _buildDragHandle(context),
              )
            : const SizedBox();
  }

  Widget _buildDragHandle(BuildContext context) {
    return Container(
      height: 4.h,
      width: 34.w,
      margin: EdgeInsets.only(top: 10.h, bottom: 5.h),
      decoration: BoxDecoration(
        color: context.greyColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            offset: const Offset(0, 0.5),
            blurRadius: 1,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //* Handler
            _buildDragHandle(context),
            //* Title
            Row(
              children: [
                const CloseButton(),
                const Gap(width: 5),
                Expanded(
                  child: Center(
                    child: TextCustom(
                      textTitle ?? '',
                      textAlign: TextAlign.center,
                      style: context.textStyle.bodyL.bw,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onAction,
                  child: TextCustom(
                    textAction ?? LocaleKeys.common_save.tr(),
                    textAlign: TextAlign.center,
                    style: context.textStyle.bodyM.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}