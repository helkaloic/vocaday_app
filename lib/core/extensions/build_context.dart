import 'package:flutter/material.dart';

import '../../app/themes/app_color.dart';
import '../../app/translations/translations.dart';

extension BuildContextExtension on BuildContext {
  /// Get screen size of current context
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width of current context
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height of current context
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get screen ratio of current context, for different devices
  int get gridRatio => MediaQuery.of(this).size.width > 900
      ? 3
      : MediaQuery.of(this).size.width > 600
          ? 2
          : 1;

  /// Get text theme of current context
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get theme of current context
  ThemeData get theme => Theme.of(this);

  /// Get brightness of current context
  Brightness get brightness => Theme.of(this).brightness;

  /// Get [bool] state of current context is dark or not
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  /// Get [Color], different with [theme.scaffoldBackgroundColor],
  /// this attribute has lighter color.
  /// [DarkBlack] for dark theme and [LightWhite] for light theme.
  Color get backgroundColor =>
      isDarkTheme ? AppColor().backgroundDark : AppColor().backgroundLight;

  /// Get [Color] for any elements have color like text widget.
  /// [Black] for light theme and [White] for dark theme
  Color get bwColor => isDarkTheme ? AppColor().white : AppColor().black;

  /// Get [Color] for any elements have color like `divider` widget.
  /// [grey300] for light theme and [grey700] for dark theme
  Color get greyColor => isDarkTheme ? AppColor().grey700 : AppColor().grey300;

  /// Get [Color] for any elements have color like `shadow` widget.
  /// [grey300] for light theme and [grey950] for dark theme
  Color get shadowColor =>
      isDarkTheme ? AppColor().grey950 : AppColor().grey300;

  /// To show date picker.
  ///
  /// * initDate: When the date picker is first displayed, if [initialDate] is not null, it will show the month of [initialDate], with [initialDate] selected. Otherwise it will show the [currentDate]'s month.
  /// * lastDate: the last date that the user could select from the date picker.
  Future<DateTime?> showDatePickerPopup({
    DateTime? initDate,
    DateTime? lastDate,
    Locale? locale,
  }) async {
    final now = DateTime.now();
    return await showDatePicker(
      context: this,
      initialDate: initDate ?? now,
      firstDate: DateTime(now.year - 100),
      lastDate: lastDate ?? now,
      currentDate: now,
      locale: locale ?? AppLocale.vi.instance,
      confirmText: LocaleKeys.common_select.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
    );
  }

  /// To show modal bottom sheet with template.
  ///
  /// * `isDismissible`: the user is allowed to dismiss the bottom sheet or not.
  /// * `isScrollControlled`: the user is allowed to scroll or not.
  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool useSafeArea = true,
    bool isDismissible = true,
    bool isScrollControlled = true,
    bool isFullScreen = false,
  }) {
    return showModalBottomSheet<T?>(
      context: this,
      useSafeArea: useSafeArea,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return isFullScreen && isScrollControlled
            ? FractionallySizedBox(heightFactor: 1, child: child)
            : child;
      },
    );
  }
}
