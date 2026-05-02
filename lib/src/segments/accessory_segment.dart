import 'package:flutter/widgets.dart';

import 'segment.dart';

/// Segment for auxiliary content that can appear inline or in a separate row.
class FloatingAccessorySegment extends FloatingSegment {
  const FloatingAccessorySegment({required this.child, super.alignment});

  /// Content rendered inside the accessory segment.
  final Widget child;
}
