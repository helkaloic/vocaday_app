import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/build_context.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({
    super.key,
    this.color,
    this.size,
    this.strokeWidth,
  });

  final Color? color;
  final Size? size;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size?.width.w ?? 20.w,
      height: size?.height.h ?? 20.h,
      child: CircularProgressIndicator(
        color: color ?? context.bwColor,
        strokeWidth: strokeWidth ?? 2.5,
      ),
    );
  }
}
