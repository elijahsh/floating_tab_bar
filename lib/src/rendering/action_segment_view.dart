import 'package:flutter/material.dart';

import '../segments/action_segment.dart';
import 'metrics.dart';
import 'segment_shell.dart';

/// Renders an action segment as one shell containing icon buttons.
class ActionSegmentView extends StatelessWidget {
  const ActionSegmentView({super.key, required this.segment});

  /// Segment model describing the action buttons.
  final FloatingActionSegment segment;

  @override
  Widget build(BuildContext context) {
    final metrics = FloatingBarMetrics.of(context);
    final innerSize = metrics.innerHeight;

    return SegmentShell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: segment.buttons.map((button) {
          Widget icon = Icon(button.icon, size: 22);
          if (button.heroTag != null) {
            icon = Hero(tag: button.heroTag!, child: icon);
          }
          return SizedBox.square(
            dimension: innerSize,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: button.onTap,
              child: Center(child: icon),
            ),
          );
        }).toList(),
      ),
    );
  }
}
