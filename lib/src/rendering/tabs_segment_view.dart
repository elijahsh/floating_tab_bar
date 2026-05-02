import 'dart:math' show max;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../controller.dart';
import '../segments/segment.dart';
import '../segments/tabs_segment.dart';
import 'animated_icon_swap.dart';
import 'metrics.dart';
import 'segment_shell.dart';

/// Renders selectable tabs, active-pill movement, and drag interactions.
class TabsSegmentView extends StatefulWidget {
  const TabsSegmentView({
    super.key,
    required this.segment,
    required this.controller,
    this.maxExpandedWidth,
  });

  /// Segment model containing tab definitions and layout strategy.
  final FloatingTabsSegment segment;

  /// Controller used to read and update the selected tab index.
  final FloatingTabBarController controller;

  /// Maximum width to use when a wide tabs segment is laid out intrinsically.
  final double? maxExpandedWidth;

  @override
  State<TabsSegmentView> createState() => _TabsSegmentViewState();
}

/// Animates selected tab changes and tracks drag selection gestures.
class _TabsSegmentViewState extends State<TabsSegmentView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _indexAnimation;
  late int _lastSelectedIndex;
  double _displayIndex = 0;
  double _dragPillDxOffset = 0;
  bool _dragging = false;
  int? _pendingIndex;
  Curve _curve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    _lastSelectedIndex = widget.controller.selectedTabIndex;
    _displayIndex = _lastSelectedIndex.toDouble();
    _indexAnimation = AlwaysStoppedAnimation(_displayIndex);
    _controller = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {
          _displayIndex = _indexAnimation.value;
        });
      });
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = FloatingBarMetrics.of(context).theme;
    _controller.duration = theme.animationDuration;
    _curve = theme.animationCurve;
  }

  @override
  void didUpdateWidget(TabsSegmentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
      _lastSelectedIndex = widget.controller.selectedTabIndex;
      _displayIndex = _lastSelectedIndex.toDouble();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    final selected = _safeSelectedIndex;
    if (_lastSelectedIndex != selected && !_dragging) {
      _lastSelectedIndex = selected;
      if (_pendingIndex == selected) {
        _pendingIndex = null;
      } else {
        _animateTo(selected.toDouble());
      }
    }
  }

  int get _safeSelectedIndex {
    final count = widget.segment.tabs.length;
    if (count == 0) return 0;
    return widget.controller.selectedTabIndex.clamp(0, count - 1);
  }

  void _animateTo(double target) {
    _indexAnimation = Tween<double>(
      begin: _displayIndex,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: _curve));
    _controller.forward(from: 0);
  }

  void _tap(int index) {
    if (index == _safeSelectedIndex) return;
    _pendingIndex = index;
    _lastSelectedIndex = index;
    _animateTo(index.toDouble());
    widget.controller.selectedTabIndex = index;
  }

  double _fractionalIndex(double dx, double totalWidth) {
    final count = widget.segment.tabs.length;
    if (count == 0 || totalWidth <= 0) return 0;
    return (dx / (totalWidth / count)).clamp(0.0, (count - 1).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final metrics = FloatingBarMetrics.of(context);
    final isFlexible = widget.segment.layout == FloatingTabsLayout.flexible;
    final expandedPill = _buildExpandedPill(context, metrics, isFlexible);
    final collapsedPill = _buildCollapsedPill(context, metrics);

    if (isFlexible) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final expandedWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : widget.maxExpandedWidth;
          final collapsedWidth = metrics.mainRowHeight;
          final width = expandedWidth == null
              ? collapsedWidth
              : lerpDouble(
                  expandedWidth,
                  collapsedWidth,
                  metrics.tabsCollapsed,
                )!;

          return SizedBox(
            width: width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: (1.0 - metrics.tabsCollapsed).clamp(0.0, 1.0),
                  child: IgnorePointer(
                    ignoring: metrics.tabsCollapsed > 0.5,
                    child: expandedPill,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Opacity(
                    opacity: metrics.tabsCollapsed,
                    child: IgnorePointer(
                      ignoring: metrics.tabsCollapsed < 0.5,
                      child: collapsedPill,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    final count = widget.segment.tabs.length;
    final tabWidth = max(metrics.innerHeight, 72.0);
    final expandedWidth = tabWidth * count + metrics.theme.pillInnerPadding * 2;
    final collapsedWidth = metrics.mainRowHeight;
    final width = lerpDouble(
      expandedWidth,
      collapsedWidth,
      metrics.tabsCollapsed,
    )!;

    return ClipRect(
      child: SizedBox(
        width: width,
        child: Stack(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.hardEdge,
          children: [
            Opacity(
              opacity: (1.0 - metrics.tabsCollapsed).clamp(0.0, 1.0),
              child: IgnorePointer(
                ignoring: metrics.tabsCollapsed > 0.5,
                child: expandedPill,
              ),
            ),
            Opacity(
              opacity: metrics.tabsCollapsed,
              child: IgnorePointer(
                ignoring: metrics.tabsCollapsed < 0.5,
                child: collapsedPill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedPill(BuildContext context, FloatingBarMetrics metrics) {
    final tabs = widget.segment.tabs;
    if (tabs.isEmpty) {
      return SegmentShell(
        child: SizedBox.square(dimension: metrics.innerHeight),
      );
    }

    final tab = tabs[_safeSelectedIndex];
    return SegmentShell(
      child: SizedBox.square(
        dimension: metrics.innerHeight,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.controller.onTabsCollapsedTap,
          child: Center(
            child: AnimatedIconSwap(
              icon: tab.activeIcon,
              theme: metrics.theme.activeTabIconTheme,
              duration: metrics.theme.animationDuration,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedPill(
    BuildContext context,
    FloatingBarMetrics metrics,
    bool isFlexible,
  ) {
    return SegmentShell(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final count = widget.segment.tabs.length;
          final tabWidth = isFlexible
              ? (count > 0 ? constraints.maxWidth / count : 0.0)
              : max(metrics.innerHeight, 72.0);
          final contentWidth = tabWidth * count;
          final activeIndex = _displayIndex.clamp(
            0.0,
            max(0, count - 1).toDouble(),
          );

          final stack = Stack(
            children: [
              if (count > 0)
                Positioned(
                  left: activeIndex * tabWidth,
                  top: 0,
                  bottom: 0,
                  width: tabWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: metrics.theme.activeTabPillColor,
                      borderRadius: BorderRadius.circular(
                        metrics.innerHeight / 2,
                      ),
                    ),
                  ),
                ),
              Row(
                children: widget.segment.tabs.asMap().entries.map((entry) {
                  final button = _TabButton(
                    tab: entry.value,
                    active: entry.key == _safeSelectedIndex,
                    onTap: () => _tap(entry.key),
                  );
                  return isFlexible
                      ? Expanded(child: button)
                      : SizedBox(width: tabWidth, child: button);
                }).toList(),
              ),
            ],
          );

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (details) {
              if (count == 0) return;
              _dragging = true;
              _controller.stop();
              _dragPillDxOffset =
                  _displayIndex.clamp(0.0, (count - 1).toDouble()) * tabWidth -
                  details.localPosition.dx;
              setState(() {
                _displayIndex = _fractionalIndex(
                  details.localPosition.dx + _dragPillDxOffset,
                  contentWidth,
                );
              });
            },
            onHorizontalDragUpdate: (details) {
              if (!_dragging) return;
              setState(() {
                _displayIndex = _fractionalIndex(
                  details.localPosition.dx + _dragPillDxOffset,
                  contentWidth,
                );
              });
            },
            onHorizontalDragEnd: (_) {
              if (count == 0) return;
              _dragging = false;
              _dragPillDxOffset = 0;
              final nearest = _displayIndex.round().clamp(0, count - 1);
              _pendingIndex = nearest;
              _lastSelectedIndex = nearest;
              _animateTo(nearest.toDouble());
              if (nearest != _safeSelectedIndex) {
                widget.controller.selectedTabIndex = nearest;
              }
            },
            onHorizontalDragCancel: () {
              if (!_dragging) return;
              _dragging = false;
              _dragPillDxOffset = 0;
              _animateTo(_safeSelectedIndex.toDouble());
            },
            child: isFlexible
                ? stack
                : OverflowBox(
                    alignment: Alignment.centerLeft,
                    minWidth: contentWidth,
                    maxWidth: contentWidth,
                    child: stack,
                  ),
          );
        },
      ),
    );
  }
}

/// Renders one tab icon and its expanding label.
class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final FloatingTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = FloatingBarMetrics.of(context);
    final theme = metrics.theme;
    final padding = EdgeInsets.lerp(
      theme.tabPadding,
      EdgeInsets.zero,
      metrics.compactness,
    )!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: metrics.innerHeight,
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: active ? theme.activeTabIconTheme : theme.tabIconTheme,
              child: Icon(active ? tab.activeIcon : tab.icon),
            ),
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: metrics.labelHeightFactor,
                child: Opacity(
                  opacity: metrics.labelOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: theme.tabIconLabelSpacing),
                      AnimatedDefaultTextStyle(
                        duration: theme.animationDuration,
                        style: active
                            ? (tab.activeLabelStyle ??
                                  theme.tabActiveLabelStyle)
                            : theme.tabLabelStyle,
                        child: Text(
                          tab.label,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
