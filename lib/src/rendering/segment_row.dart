import 'package:flutter/widgets.dart';

import '../segments/segment.dart';

/// Describes one segment view and how it should be placed in the bar row.
class SegmentRowItem {
  const SegmentRowItem({
    required this.alignment,
    required this.child,
    this.flexible = false,
  });

  /// Horizontal alignment group used when all row items have intrinsic width.
  final FloatingSegmentAlignment alignment;

  /// Rendered segment content.
  final Widget child;

  /// Whether this item should expand when the row needs flexible layout.
  final bool flexible;
}

/// Lays out floating tab bar segments with spacing and alignment groups.
class SegmentRow extends StatelessWidget {
  const SegmentRow({super.key, required this.spacing, required this.items});

  /// Horizontal spacing inserted between adjacent segment views.
  final double spacing;

  /// Segment views to render from left to right.
  final List<SegmentRowItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final hasFlexible = items.any((item) => item.flexible);
    if (hasFlexible) {
      return Row(children: _spaced(items.map(_buildFlexibleAware).toList()));
    }

    final start = items
        .where((item) => item.alignment == FloatingSegmentAlignment.start)
        .toList();
    final center = items
        .where((item) => item.alignment == FloatingSegmentAlignment.center)
        .toList();
    final end = items
        .where((item) => item.alignment == FloatingSegmentAlignment.end)
        .toList();

    return Row(
      children: [
        _IntrinsicSegmentGroup(spacing: spacing, items: start),
        const Spacer(),
        _IntrinsicSegmentGroup(spacing: spacing, items: center),
        const Spacer(),
        _IntrinsicSegmentGroup(spacing: spacing, items: end),
      ],
    );
  }

  Widget _buildFlexibleAware(SegmentRowItem item) =>
      item.flexible ? Expanded(child: item.child) : item.child;

  List<Widget> _spaced(List<Widget> children) {
    if (children.length < 2) return children;
    return [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) SizedBox(width: spacing),
        children[i],
      ],
    ];
  }
}

/// Intrinsic-width row for one segment alignment group.
class _IntrinsicSegmentGroup extends StatelessWidget {
  const _IntrinsicSegmentGroup({required this.spacing, required this.items});

  final double spacing;
  final List<SegmentRowItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          items[i].child,
        ],
      ],
    );
  }
}
