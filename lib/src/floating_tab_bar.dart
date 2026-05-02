import 'package:flutter/material.dart';

import 'controller.dart';
import 'rendering/accessory_segment_view.dart';
import 'rendering/action_segment_view.dart';
import 'rendering/metrics.dart';
import 'rendering/options_segment_view.dart';
import 'rendering/search_segment_view.dart';
import 'rendering/segment_row.dart';
import 'rendering/tabs_segment_view.dart';
import 'segments/accessory_segment.dart';
import 'segments/action_segment.dart';
import 'segments/options_segment.dart';
import 'segments/search_segment.dart';
import 'segments/segment.dart';
import 'segments/tabs_segment.dart';
import 'theme.dart';

export 'controller.dart';
export 'rendering/pill.dart' show FloatingBarAnimValue;
export 'segments/accessory_segment.dart';
export 'segments/action_segment.dart';
export 'segments/options_segment.dart';
export 'segments/search_segment.dart';
export 'segments/segment.dart';
export 'segments/tabs_segment.dart';
export 'theme.dart';

/// A floating, animated tab bar assembled from configurable segments.
class FloatingTabBar extends StatefulWidget {
  const FloatingTabBar({
    super.key,
    required this.controller,
    required this.segments,
    this.theme,
    this.safeAreaPadding,
  });

  /// Drives the selected tab, search mode, options state, and bar size.
  final FloatingTabBarController controller;

  /// Segment models rendered in the main row and optional accessory row.
  final List<FloatingSegment> segments;

  /// Optional theme override for this tab bar.
  final FloatingTabBarThemeData? theme;

  /// Additional safe-area padding applied outside [theme.tabBarPadding].
  final EdgeInsets? safeAreaPadding;

  @override
  State<FloatingTabBar> createState() => _FloatingTabBarState();
}

/// Maintains the animation controller and builds the current bar frame.
class _FloatingTabBarState extends State<FloatingTabBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;
  late FloatingBarVisualState _fromVisual;
  late FloatingBarVisualState _toVisual;
  late FloatingSearchState _previousSearchState;

  @override
  void initState() {
    super.initState();
    _assertSegmentTypes(widget.segments);
    _toVisual = _visualTargetFor(widget.controller);
    _fromVisual = _toVisual;
    _previousSearchState = widget.controller.searchState;
    _animation = AnimationController(vsync: this, value: 1.0);
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(FloatingTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
      _toVisual = _visualTargetFor(widget.controller);
      _fromVisual = _toVisual;
      _previousSearchState = widget.controller.searchState;
      _animation.value = 1.0;
    }
    if (oldWidget.segments != widget.segments) {
      _assertSegmentTypes(widget.segments);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _animation.dispose();
    super.dispose();
  }

  static void _assertSegmentTypes(List<FloatingSegment> segments) {
    assert(
      segments.whereType<FloatingTabsSegment>().length <= 1,
      'FloatingTabBar: at most one FloatingTabsSegment is allowed.',
    );
    assert(
      segments.whereType<FloatingSearchSegment>().length <= 1,
      'FloatingTabBar: at most one FloatingSearchSegment is allowed.',
    );
    assert(
      segments.whereType<FloatingOptionsSegment>().length <= 1,
      'FloatingTabBar: at most one FloatingOptionsSegment is allowed.',
    );
    assert(
      segments.whereType<FloatingAccessorySegment>().length <= 1,
      'FloatingTabBar: at most one FloatingAccessorySegment is allowed.',
    );
  }

  FloatingBarVisualState get _currentVisual {
    final theme = widget.theme ?? FloatingTabBarThemeData.of(context);
    final t = theme.animationCurve.transform(_animation.value);
    return FloatingBarVisualState.lerp(_fromVisual, _toVisual, t);
  }

  FloatingBarVisualState _visualTargetFor(FloatingTabBarController controller) {
    return FloatingBarVisualState(
      bar: switch (controller.state) {
        FloatingTabBarState.expanded => 0.0,
        FloatingTabBarState.compact => 0.5,
        FloatingTabBarState.minimized => 1.0,
      },
      tabsCollapsed: controller.tabsCollapsed ? 1.0 : 0.0,
      search: switch (controller.searchState) {
        FloatingSearchState.button => 0.0,
        FloatingSearchState.expanded => 0.5,
        FloatingSearchState.input => 1.0,
      },
      options: controller.optionsExpanded ? 1.0 : 0.0,
      accessory:
          controller.accessoryPlacement == FloatingAccessoryPlacement.separate
          ? 1.0
          : 0.0,
    );
  }

  void _handleControllerChanged() {
    final theme = widget.theme ?? FloatingTabBarThemeData.of(context);
    final searchState = widget.controller.searchState;
    final snapSearchTransition = _snapsSearchTransition(
      _previousSearchState,
      searchState,
    );
    _previousSearchState = searchState;
    final targetVisual = _visualTargetFor(widget.controller);
    if (snapSearchTransition) {
      setState(() {
        _fromVisual = targetVisual;
        _toVisual = targetVisual;
        _animation.value = 1.0;
      });
      return;
    }

    _fromVisual = _currentVisual;
    _toVisual = targetVisual;
    _animation
      ..duration = theme.animationDuration
      ..forward(from: 0);
  }

  bool _snapsSearchTransition(
    FloatingSearchState previous,
    FloatingSearchState next,
  ) {
    return previous != next &&
        previous != FloatingSearchState.button &&
        next != FloatingSearchState.button;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? FloatingTabBarThemeData.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final visual = _currentVisual;
        final metrics = FloatingBarMetrics(theme: theme, visual: visual);
        final keyboardInset =
            widget.controller.searchState == FloatingSearchState.input
            ? MediaQuery.viewInsetsOf(context).bottom
            : 0.0;

        return FloatingBarMetricsScope(
          metrics: metrics,
          child: Padding(
            padding: theme.tabBarPadding.copyWith(
              bottom:
                  theme.tabBarPadding.bottom +
                  keyboardInset +
                  (widget.safeAreaPadding?.bottom ?? 0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_topRowVisible(metrics)) _buildTopRow(metrics),
                _buildMainRow(metrics),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _topRowVisible(FloatingBarMetrics metrics) =>
      widget.controller.searchState != FloatingSearchState.input &&
      widget.segments.whereType<FloatingAccessorySegment>().isNotEmpty &&
      metrics.accessory > 0.001;

  Widget _buildTopRow(FloatingBarMetrics metrics) {
    final accessory = widget.segments
        .whereType<FloatingAccessorySegment>()
        .first;
    final accessorySettled = metrics.accessory >= 0.999;
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: metrics.accessory,
        child: Padding(
          padding: EdgeInsets.only(bottom: metrics.theme.segmentsSpacing),
          child: IgnorePointer(
            ignoring: !accessorySettled,
            child: SizedBox(
              height: metrics.topRowHeight,
              child: Row(
                children: [
                  Expanded(
                    child: accessorySettled
                        ? AccessorySegmentView(
                            segment: accessory,
                            height: metrics.topRowHeight,
                          )
                        : const SizedBox.expand(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainRow(FloatingBarMetrics metrics) {
    final rowMetrics = _metricsForMainRow(metrics);
    return FloatingBarMetricsScope(
      metrics: rowMetrics,
      child: _buildFullMainRow(rowMetrics),
    );
  }

  FloatingBarMetrics _metricsForMainRow(FloatingBarMetrics metrics) {
    final minimized = metrics.minimizedProgress;
    if (minimized <= 0 || metrics.tabsCollapsed >= minimized) {
      return metrics;
    }

    return metrics.withVisual(
      FloatingBarVisualState(
        bar: metrics.visual.bar,
        tabsCollapsed: minimized,
        search: metrics.visual.search,
        options: metrics.visual.options,
        accessory: metrics.visual.accessory,
      ),
    );
  }

  Widget _buildFullMainRow(FloatingBarMetrics metrics) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final items = widget.segments
            .map(
              (segment) => _itemForSegment(
                segment,
                metrics,
                rowMaxWidth: constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : null,
              ),
            )
            .nonNulls
            .toList();
        return SizedBox(
          height: metrics.mainRowHeight,
          child: SegmentRow(
            spacing: metrics.theme.segmentsSpacing,
            items: items,
          ),
        );
      },
    );
  }

  SegmentRowItem? _itemForSegment(
    FloatingSegment segment,
    FloatingBarMetrics metrics, {
    double? rowMaxWidth,
  }) {
    final searchInput =
        widget.controller.searchState == FloatingSearchState.input;
    if (searchInput && segment is! FloatingSearchSegment) {
      return null;
    }

    return switch (segment) {
      FloatingTabsSegment tabs => SegmentRowItem(
        alignment: tabs.alignment,
        flexible:
            tabs.layout == FloatingTabsLayout.flexible &&
            metrics.tabsCollapsed <= 0.001,
        child: TabsSegmentView(
          segment: tabs,
          controller: widget.controller,
          maxExpandedWidth: _wideTabsExpandedWidth(metrics, rowMaxWidth),
        ),
      ),
      FloatingActionSegment() when metrics.minimizedProgress >= 0.999 => null,
      FloatingActionSegment action => SegmentRowItem(
        alignment: action.alignment,
        child: _hideWhenMinimized(
          metrics: metrics,
          child: ActionSegmentView(segment: action),
        ),
      ),
      FloatingOptionsSegment() when metrics.minimizedProgress >= 0.999 => null,
      FloatingOptionsSegment options => SegmentRowItem(
        alignment: options.alignment,
        child: _hideWhenMinimized(
          metrics: metrics,
          child: OptionsSegmentView(
            segment: options,
            controller: widget.controller,
          ),
        ),
      ),
      FloatingSearchSegment() when metrics.minimizedProgress >= 0.999 => null,
      FloatingSearchSegment search => SegmentRowItem(
        alignment: search.alignment,
        flexible: metrics.search > 0.001 && metrics.minimizedProgress <= 0.001,
        child: _hideWhenMinimized(
          metrics: metrics,
          child: SearchSegmentView(
            segment: search,
            controller: widget.controller,
          ),
        ),
      ),
      FloatingAccessorySegment() when metrics.accessory >= 0.999 => null,
      FloatingAccessorySegment() when metrics.minimizedProgress >= 0.999 =>
        null,
      FloatingAccessorySegment accessory => SegmentRowItem(
        alignment: accessory.alignment,
        flexible: metrics.minimizedProgress <= 0.001,
        child: _hideWhenMinimized(
          metrics: metrics,
          child: Transform.translate(
            offset: Offset(
              0,
              -_accessoryRowTravel(metrics) * metrics.accessory,
            ),
            child: IgnorePointer(
              ignoring: metrics.accessory > 0.01,
              child: AccessorySegmentView(segment: accessory),
            ),
          ),
        ),
      ),
      _ => null,
    };
  }

  double _accessoryRowTravel(FloatingBarMetrics metrics) =>
      metrics.topRowHeight + metrics.theme.segmentsSpacing;

  double? _wideTabsExpandedWidth(
    FloatingBarMetrics metrics,
    double? rowMaxWidth,
  ) {
    if (rowMaxWidth == null) return null;

    final visibleNonTabCount = widget.segments.where((segment) {
      return segment is! FloatingTabsSegment &&
          segment is! FloatingAccessorySegment &&
          !(segment is FloatingActionSegment &&
              metrics.minimizedProgress >= 0.999) &&
          !(segment is FloatingOptionsSegment &&
              metrics.minimizedProgress >= 0.999) &&
          !(segment is FloatingSearchSegment &&
              metrics.minimizedProgress >= 0.999);
    }).length;

    if (visibleNonTabCount == 0) return rowMaxWidth;

    final spacing = metrics.theme.segmentsSpacing * visibleNonTabCount;
    final compactSegmentsWidth = metrics.mainRowHeight * visibleNonTabCount;
    return (rowMaxWidth - spacing - compactSegmentsWidth).clamp(
      metrics.mainRowHeight,
      rowMaxWidth,
    );
  }

  Widget _hideWhenMinimized({
    required FloatingBarMetrics metrics,
    required Widget child,
  }) {
    final visible = (1.0 - metrics.minimizedProgress).clamp(0.0, 1.0);
    if (visible >= 0.999) return child;
    if (visible <= 0.001) {
      return const SizedBox.shrink();
    }

    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: visible,
        child: Opacity(
          opacity: visible,
          child: IgnorePointer(ignoring: visible < 0.99, child: child),
        ),
      ),
    );
  }
}
