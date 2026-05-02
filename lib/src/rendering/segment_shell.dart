import 'dart:ui';

import 'package:flutter/material.dart';

import 'metrics.dart';

/// Shared blurred, rounded shell used by every floating tab bar segment.
class SegmentShell extends StatelessWidget {
  const SegmentShell({
    super.key,
    required this.child,
    this.height,
    this.padding,
  });

  /// Content placed inside the shell.
  final Widget child;

  /// Optional height override; defaults to the current main row height.
  final double? height;

  /// Optional inner padding; defaults to the theme pill padding.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final metrics = FloatingBarMetrics.of(context);
    final theme = metrics.theme;
    final effectiveHeight = height ?? metrics.mainRowHeight;
    final radius = effectiveHeight / 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: theme.pillBlurSigma,
          sigmaY: theme.pillBlurSigma,
        ),
        child: Container(
          height: effectiveHeight,
          decoration: BoxDecoration(
            color: theme.pillBackgroundColor,
            borderRadius: BorderRadius.circular(radius),
            border: theme.pillBorder,
          ),
          padding: padding ?? EdgeInsets.all(theme.pillInnerPadding),
          child: child,
        ),
      ),
    );
  }
}
