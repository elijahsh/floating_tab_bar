import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme.dart';
import 'metrics.dart';
import 'segment_shell.dart';

/// Shared animation values driven by a single source of truth in FloatingTabBar.
///
/// - [value]: bar compactness 0=expanded, 0.5=compact, 1=minimized
/// - [tabsCollapsed]: 0=full tabs row, 1=single collapsed pill
/// - [searchAnim]: 0=button, 0.5=expanded hint, 1=text input
/// - [optionsAnim]: 0=icon-only, 1=expanded child revealed
/// - [accessoryAnim]: 0=inline, 1=separate top row
class FloatingBarAnimValue extends InheritedWidget {
  const FloatingBarAnimValue({
    super.key,
    required this.value,
    required this.tabsCollapsed,
    required this.searchAnim,
    required this.optionsAnim,
    required this.accessoryAnim,
    required super.child,
  });

  final double value;
  final double tabsCollapsed;
  final double searchAnim;
  final double optionsAnim;
  final double accessoryAnim;

  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<FloatingBarAnimValue>()
          ?.value ??
      0.0;

  static double tabsCollapsedOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<FloatingBarAnimValue>()
          ?.tabsCollapsed ??
      0.0;

  static double searchAnimOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<FloatingBarAnimValue>()
          ?.searchAnim ??
      0.0;

  static double optionsAnimOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<FloatingBarAnimValue>()
          ?.optionsAnim ??
      0.0;

  static double accessoryAnimOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<FloatingBarAnimValue>()
          ?.accessoryAnim ??
      0.0;

  @override
  bool updateShouldNotify(FloatingBarAnimValue old) =>
      value != old.value ||
      tabsCollapsed != old.tabsCollapsed ||
      searchAnim != old.searchAnim ||
      optionsAnim != old.optionsAnim ||
      accessoryAnim != old.accessoryAnim;
}

/// Pill-shaped blurred container. Height is interpolated from the inherited
/// [FloatingBarAnimValue] between [expandedHeight] and [compactHeight].
class FloatingPill extends StatelessWidget {
  const FloatingPill({
    super.key,
    required this.child,
    this.expandedHeight,
    this.compactHeight,
  });

  final Widget child;
  final double? expandedHeight;
  final double? compactHeight;

  @override
  Widget build(BuildContext context) {
    final theme = FloatingTabBarThemeData.of(context);
    final inheritedMetrics = context
        .dependOnInheritedWidgetOfExactType<FloatingBarMetricsScope>();
    final t =
        inheritedMetrics?.metrics.barValue ?? FloatingBarAnimValue.of(context);
    final height = lerpDouble(
      expandedHeight ?? theme.expandedHeight,
      compactHeight ?? theme.compactHeight,
      (t * 2).clamp(0.0, 1.0),
    )!;

    return SegmentShell(height: height, child: child);
  }
}
