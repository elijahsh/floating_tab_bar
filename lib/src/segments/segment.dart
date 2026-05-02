/// Horizontal placement used by non-flexible tab bar segments.
enum FloatingSegmentAlignment { start, center, end }

/// Layout strategy for the tabs segment in the main bar row.
enum FloatingTabsLayout { intrinsic, flexible }

/// Visual and interaction state for the search segment.
enum FloatingSearchState { button, expanded, input }

/// Placement mode for accessory content.
enum FloatingAccessoryPlacement { separate, inline }

/// Base configuration object for a floating tab bar segment.
abstract class FloatingSegment {
  const FloatingSegment({this.alignment = FloatingSegmentAlignment.start});

  /// Alignment group used when the segment is laid out in the main row.
  final FloatingSegmentAlignment alignment;
}
