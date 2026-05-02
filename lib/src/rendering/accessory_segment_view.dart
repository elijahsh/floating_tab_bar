import 'package:flutter/material.dart';

import '../segments/accessory_segment.dart';
import 'metrics.dart';
import 'segment_shell.dart';

/// Renders accessory content in the floating segment shell.
class AccessorySegmentView extends StatelessWidget {
  const AccessorySegmentView({super.key, required this.segment, this.height});

  /// Segment model containing the accessory child widget.
  final FloatingAccessorySegment segment;

  /// Optional shell height override, used when the accessory is in the top row.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final metrics = FloatingBarMetrics.of(context);
    return SegmentShell(
      height: height ?? metrics.mainRowHeight,
      child: segment.child,
    );
  }
}
