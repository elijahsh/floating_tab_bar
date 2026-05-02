import 'package:flutter/widgets.dart';

import 'segment.dart';

/// Segment that toggles between an icon button and expanded option content.
class FloatingOptionsSegment extends FloatingSegment {
  const FloatingOptionsSegment({
    required this.icon,
    required this.expandedChild,
    this.heroTag,
    super.alignment,
  });

  /// Icon displayed while options are collapsed.
  final IconData icon;

  /// Content revealed when the options segment is expanded.
  final Widget expandedChild;

  /// Optional hero tag for integrations that animate the options control.
  final Object? heroTag;
}
