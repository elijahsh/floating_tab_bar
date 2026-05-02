import 'package:flutter/widgets.dart';

import 'segment.dart';

/// Describes one tappable icon action in a [FloatingActionSegment].
class ActionButton {
  const ActionButton({required this.icon, required this.onTap, this.heroTag});

  /// Icon displayed inside the action pill.
  final IconData icon;

  /// Callback invoked when the action is tapped.
  final VoidCallback onTap;

  /// Optional hero tag for integrations that animate the action elsewhere.
  final Object? heroTag;
}

/// Segment that displays one or more icon action buttons.
class FloatingActionSegment extends FloatingSegment {
  const FloatingActionSegment({required this.buttons, super.alignment})
    : assert(buttons.length > 0);

  /// Buttons rendered by this segment.
  final List<ActionButton> buttons;
}
