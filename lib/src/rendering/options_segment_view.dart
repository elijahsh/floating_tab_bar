import 'package:flutter/material.dart';

import '../controller.dart';
import '../segments/options_segment.dart';
import 'metrics.dart';
import 'segment_shell.dart';

/// Renders the collapsible options segment and its expanded content.
class OptionsSegmentView extends StatelessWidget {
  const OptionsSegmentView({
    super.key,
    required this.segment,
    required this.controller,
  });

  /// Segment model describing the options icon and expanded content.
  final FloatingOptionsSegment segment;

  /// Controller used to toggle the options expanded state.
  final FloatingTabBarController controller;

  @override
  Widget build(BuildContext context) {
    final metrics = FloatingBarMetrics.of(context);
    final innerSize = metrics.innerHeight;

    Widget icon = Icon(segment.icon, size: 22);
    if (segment.heroTag != null) {
      icon = Hero(tag: segment.heroTag!, child: icon);
    }

    return SegmentShell(
      child: ClipRect(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: innerSize,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.toggleOptions,
                child: Center(child: icon),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              widthFactor: metrics.options,
              child: SizedBox(height: innerSize, child: segment.expandedChild),
            ),
          ],
        ),
      ),
    );
  }
}
