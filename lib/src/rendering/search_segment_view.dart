import 'package:flutter/material.dart';

import '../controller.dart';
import '../segments/action_segment.dart';
import '../segments/search_segment.dart';
import '../segments/segment.dart';
import 'action_segment_view.dart';
import 'metrics.dart';
import 'segment_shell.dart';

/// Renders the animated search button, prompt, and focused text input.
class SearchSegmentView extends StatefulWidget {
  const SearchSegmentView({
    super.key,
    required this.segment,
    required this.controller,
  });

  /// Segment model describing hint text and optional microphone action.
  final FloatingSearchSegment segment;

  /// Controller used to read search state and text input.
  final FloatingTabBarController controller;

  @override
  State<SearchSegmentView> createState() => _SearchSegmentViewState();
}

/// Tracks focus as the search segment enters or exits input mode.
class _SearchSegmentViewState extends State<SearchSegmentView> {
  late final FocusNode _focusNode;
  late FloatingSearchState _previousState;
  bool _focusRequestScheduled = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _previousState = widget.controller.searchState;
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(SearchSegmentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
      _previousState = widget.controller.searchState;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    final state = widget.controller.searchState;
    if (state != FloatingSearchState.input &&
        _previousState == FloatingSearchState.input) {
      _focusNode.unfocus();
    }
    _previousState = state;
  }

  void _scheduleInputFocus() {
    if (_focusRequestScheduled) return;
    _focusRequestScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusRequestScheduled = false;
      if (!mounted ||
          widget.controller.searchState != FloatingSearchState.input) {
        return;
      }
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final metrics = FloatingBarMetrics.of(context);
    final theme = metrics.theme;
    final innerSize = metrics.innerHeight;
    final search = metrics.search;

    final buttonOpacity = (1.0 - search * 2).clamp(0.0, 1.0);
    final expandedOpacity = (1.0 - (search - 0.5).abs() * 2).clamp(0.0, 1.0);
    final inputOpacity = ((search - 0.5) * 2).clamp(0.0, 1.0);
    final inputVisible =
        widget.controller.searchState == FloatingSearchState.input ||
        inputOpacity > 0;

    if (widget.controller.searchState == FloatingSearchState.input &&
        inputOpacity >= 1) {
      _scheduleInputFocus();
    }

    final searchShell = SegmentShell(
      child: Stack(
        children: [
          Opacity(
            opacity: buttonOpacity,
            child: IgnorePointer(
              ignoring: buttonOpacity < 0.5,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  widget.controller.searchState = FloatingSearchState.expanded;
                },
                child: SizedBox.square(
                  dimension: innerSize,
                  child: Center(
                    child: IconTheme(
                      data: theme.searchIconTheme,
                      child: const Icon(Icons.search_rounded),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (expandedOpacity > 0)
            Positioned.fill(
              child: Opacity(
                opacity: expandedOpacity,
                child: IgnorePointer(
                  ignoring: expandedOpacity < 0.5,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.controller.searchState = FloatingSearchState.input;
                    },
                    child: _SearchRow.prompt(segment: widget.segment),
                  ),
                ),
              ),
            ),
          if (inputVisible)
            Positioned.fill(
              child: Opacity(
                opacity: inputOpacity,
                child: IgnorePointer(
                  ignoring: inputOpacity < 0.5,
                  child: _SearchRow.input(
                    segment: widget.segment,
                    controller: widget.controller,
                    focusNode: _focusNode,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (!inputVisible) return searchShell;

    return Row(
      children: [
        Expanded(child: searchShell),
        SizedBox(width: theme.segmentsSpacing),
        Opacity(
          opacity: inputOpacity,
          child: IgnorePointer(
            ignoring: inputOpacity < 0.5,
            child: ActionSegmentView(
              segment: FloatingActionSegment(
                buttons: [
                  ActionButton(
                    icon: widget.segment.closeIcon,
                    onTap: _handleCloseTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleCloseTap() {
    final onCloseTap = widget.segment.onCloseTap;
    if (onCloseTap != null) {
      onCloseTap();
      return;
    }
    widget.controller.searchState = FloatingSearchState.expanded;
  }
}

/// Renders the shared search row chrome with either prompt text or an input.
class _SearchRow extends StatelessWidget {
  const _SearchRow.prompt({required this.segment})
    : controller = null,
      focusNode = null;

  const _SearchRow.input({
    required this.segment,
    required this.controller,
    required this.focusNode,
  });

  final FloatingSearchSegment segment;
  final FloatingTabBarController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = FloatingBarMetrics.of(context).theme;
    final controller = this.controller;
    return Row(
      children: [
        const SizedBox(width: 4),
        IconTheme(
          data: theme.searchIconTheme,
          child: const Icon(Icons.search_rounded),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: controller == null
              ? Text(
                  segment.hint,
                  style: theme.searchInputDecorationTheme.hintStyle,
                  overflow: TextOverflow.ellipsis,
                )
              : Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: theme.searchInputDecorationTheme,
                  ),
                  child: TextField(
                    controller: controller.searchTextController,
                    focusNode: focusNode,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: segment.hint,
                    ),
                    onSubmitted: (_) {
                      controller.searchState = FloatingSearchState.expanded;
                    },
                  ),
                ),
        ),
        if (segment.showMic)
          IconTheme(
            data: theme.searchIconTheme,
            child: GestureDetector(
              onTap: segment.onMicTap,
              child: const Icon(Icons.mic_none_rounded),
            ),
          ),
        const SizedBox(width: 4),
      ],
    );
  }
}
