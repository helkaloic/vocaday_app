import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';
import '../../core/extensions/color.dart';
import '../themes/app_color.dart';
import 'text.dart';

enum PushableButtonType { primary, accent, grey, disable }

class PushableButton extends StatefulWidget {
  const PushableButton({
    super.key,
    required this.onPressed,
    this.child,
    this.text = 'Button',
    this.height = 52,
    this.width,
    this.elevation = 5.0,
    this.border = 10,
    this.borderColor,
    this.duration = 350,
    this.type = PushableButtonType.primary,
    this.textColor,
  });

  final Widget? child;
  final String text;
  final double height;
  final double? width;
  final double elevation;
  final Color? textColor;
  final double border;
  final Color? borderColor;
  final int duration;
  final PushableButtonType type;
  final VoidCallback onPressed;

  @override
  State<PushableButton> createState() => _PushableButtonState();
}

class _PushableButtonState extends State<PushableButton> {
  late double _elevation;
  late double _borderRadiusFixed;
  @override
  void initState() {
    super.initState();
    _elevation = widget.elevation.h;
    _borderRadiusFixed = widget.border.r + (widget.border.r / 2 - 1.r);
  }

  Decoration? get _boxDecoration {
    final backgroundColor = switch (widget.type) {
      PushableButtonType.primary => context.theme.primaryColor,
      PushableButtonType.accent => AppColor.accent,
      PushableButtonType.grey => context.theme.dividerColor.withOpacity(.7),
      PushableButtonType.disable => AppColor.grey,
    };
    return BoxDecoration(
      color: backgroundColor,
      border: Border(
        bottom: BorderSide(
          color: widget.type == PushableButtonType.disable
              ? backgroundColor
              : backgroundColor.darken(
                  context.isDarkTheme ? 0.1 : 0.15,
                ),
          width: _elevation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _elevation = 0.0),
      onTapUp: (_) => setState(() => _elevation = widget.elevation.h),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.border.r),
          topRight: Radius.circular(widget.border.r),
          bottomLeft: Radius.circular(_borderRadiusFixed),
          bottomRight: Radius.circular(_borderRadiusFixed),
        ),
        child: AnimatedContainer(
          height: widget.height.h,
          width: widget.width?.w,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: widget.duration),
          decoration: _boxDecoration,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.width == null ? 20.w : 0),
              child: widget.child ??
                  TextCustom(
                    widget.text,
                    fontWeight: FontWeight.w500,
                    color: widget.textColor ?? AppColor.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}