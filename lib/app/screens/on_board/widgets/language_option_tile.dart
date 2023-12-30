import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../widgets/gap.dart';
import '../../../widgets/text.dart';

class LanguageOptionWidget extends StatelessWidget {
  const LanguageOptionWidget({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    required this.isSelected,
  });

  final VoidCallback onTap;
  final bool isSelected;
  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Durations.short3,
        margin: EdgeInsets.symmetric(vertical: 10.h / 2),
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 10.w * 1.5,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.theme.primaryColor.withOpacity(.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? context.theme.primaryColor
                : context.theme.dividerColor.withOpacity(.3),
            width: isSelected ? 2.75 : 2,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedContainer(
              duration: Durations.medium2,
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                border: Border.all(
                  color: isSelected
                      ? context.theme.primaryColor
                      : context.theme.dividerColor.withOpacity(.4),
                  width: isSelected ? 8 : 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
            ),
            const Gap(width: 20),
            TextCustom(
              text,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: isSelected
                  ? context.textTheme.bodyMedium?.color
                  : context.textTheme.bodyMedium?.color,
            ),
            const Spacer(),
            SvgPicture.asset(
              icon,
              height: 45.h,
            ),
          ],
        ),
      ),
    );
  }
}