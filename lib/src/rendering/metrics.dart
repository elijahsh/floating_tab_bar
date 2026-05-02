import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../theme.dart';

/// Interpolatable visual state used to drive all loating tab bar animations.
@immutable
class FloatingBarVisualState {
  const FloatingBarVisualState({
    required this.bar,
    required this.tabsCollapsed,
    required this.search,
    required this.options,
    required this.accessory,
  });

  /// Bar progress where 0 is expanded, 0.5 is compact, and 1 is minimized.
  final double bar;

  /// Progress from full tabs to collapsed selected-tab pill.
  final double tabsCollapsed;

  /// Search progress where 0 is button, 0.5 is prompt, and 1 is input.
  final double search;

  /// Progress from collapsed options icon to expanded options content.
  final double options;

  /// Progress from inline accessory placement to separate top-row placement.
  final double accessory;

  static FloatingBarVisualState lerp(
    FloatingBarVisualState a,
    FloatingBarVisualState b,
    double t,
  ) {
    return FloatingBarVisualState(
      bar: lerpDouble(a.bar, b.bar, t)!,
      tabsCollapsed: lerpDouble(a.tabsCollapsed, b.tabsCollapsed, t)!,
      search: lerpDouble(a.search, b.search, t)!,
      options: lerpDouble(a.options, b.options, t)!,
      accessory: lerpDouble(a.accessory, b.accessory, t)!,
    );
  }
}

/// Derived geometry and animation values for the current tab bar frame.
@immutable
class FloatingBarMetrics {
  const FloatingBarMetrics({required this.theme, required this.visual});

  /// Theme values used to calculate dimensions.
  final FloatingTabBarThemeData theme;

  /// Current animated visual state.
  final FloatingBarVisualState visual;

  double get barValue => visual.bar;

  double get tabsCollapsed => visual.tabsCollapsed;

  double get search => visual.search;

  double get options => visual.options;

  double get accessory => visual.accessory;

  double get compactness => (barValue * 2).clamp(0.0, 1.0);

  double get mainRowHeight =>
      lerpDouble(theme.expandedHeight, theme.compactHeight, compactness)!;

  double get topRowHeight => theme.compactHeight;

  double get innerHeight => mainRowHeight - theme.pillInnerPadding * 2;

  double get compactInnerHeight => topRowHeight - theme.pillInnerPadding * 2;

  double get pillRadius => mainRowHeight / 2;

  double get labelHeightFactor => (1.0 - compactness).clamp(0.0, 1.0);

  double get labelOpacity => (1.0 - compactness * 2).clamp(0.0, 1.0);

  double get minimizedProgress => ((barValue - 0.7) / 0.3).clamp(0.0, 1.0);

  FloatingBarMetrics withVisual(FloatingBarVisualState value) =>
      FloatingBarMetrics(theme: theme, visual: value);

  static FloatingBarMetrics of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<FloatingBarMetricsScope>()
          ?.metrics ??
      FloatingBarMetrics(
        theme: FloatingTabBarThemeData.of(context),
        visual: const FloatingBarVisualState(
          bar: 0.0,
          tabsCollapsed: 0.0,
          search: 0.0,
          options: 0.0,
          accessory: 0.0,
        ),
      );
}

/// Inherited scope that makes [FloatingBarMetrics] available to segment views.
class FloatingBarMetricsScope extends InheritedWidget {
  const FloatingBarMetricsScope({
    super.key,
    required this.metrics,
    required super.child,
  });

  /// Metrics for the nearest floating tab bar.
  final FloatingBarMetrics metrics;

  @override
  bool updateShouldNotify(FloatingBarMetricsScope oldWidget) =>
      metrics.theme != oldWidget.metrics.theme ||
      metrics.visual.bar != oldWidget.metrics.visual.bar ||
      metrics.visual.tabsCollapsed != oldWidget.metrics.visual.tabsCollapsed ||
      metrics.visual.search != oldWidget.metrics.visual.search ||
      metrics.visual.options != oldWidget.metrics.visual.options ||
      metrics.visual.accessory != oldWidget.metrics.visual.accessory;
}
