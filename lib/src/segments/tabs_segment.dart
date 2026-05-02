import 'package:flutter/widgets.dart';

import 'segment.dart';

/// Describes a selectable tab displayed by [FloatingTabsSegment].
class FloatingTab {
  const FloatingTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.activeLabelStyle,
  });

  /// Icon shown when this tab is not selected.
  final IconData icon;

  /// Icon shown when this tab is selected.
  final IconData activeIcon;

  /// Text label shown in expanded tab layouts.
  final String label;

  /// Optional label style override used when this tab is selected.
  final TextStyle? activeLabelStyle;
}

/// Segment that renders a list of selectable tabs.
class FloatingTabsSegment extends FloatingSegment {
  const FloatingTabsSegment({
    required this.tabs,
    this.layout = FloatingTabsLayout.flexible,
    super.alignment,
  });

  /// Tabs available in this segment.
  final List<FloatingTab> tabs;

  /// Controls whether the segment can expand to fill available row space.
  final FloatingTabsLayout layout;
}
