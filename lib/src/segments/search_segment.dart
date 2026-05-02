import 'package:flutter/material.dart';

import 'segment.dart';

/// Segment that renders the search affordance, prompt, and text input states.
class FloatingSearchSegment extends FloatingSegment {
  const FloatingSearchSegment({
    this.hint = 'Search',
    this.showMic = false,
    this.onMicTap,
    this.closeIcon = Icons.close_rounded,
    this.onCloseTap,
    super.alignment,
  });

  /// Placeholder text shown before the user enters a query.
  final String hint;

  /// Whether to show a microphone action alongside search.
  final bool showMic;

  /// Callback invoked when the microphone action is tapped.
  final VoidCallback? onMicTap;

  /// Icon displayed in the close action while search is accepting input.
  final IconData closeIcon;

  /// Callback invoked when the close action is tapped.
  ///
  /// When omitted, the search state returns to [FloatingSearchState.button].
  final VoidCallback? onCloseTap;
}
