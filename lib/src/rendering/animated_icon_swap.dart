import 'package:flutter/material.dart';

import '../theme.dart';

/// Cross-fades between two icons when [icon] changes.
/// [duration] defaults to [FloatingTabBarThemeData.animationDuration] if null.
class AnimatedIconSwap extends StatefulWidget {
  const AnimatedIconSwap({
    super.key,
    required this.icon,
    required this.theme,
    this.duration,
  });

  final IconData icon;
  final IconThemeData theme;
  final Duration? duration;

  @override
  State<AnimatedIconSwap> createState() => _AnimatedIconSwapState();
}

/// Rebuilds the icon switcher when [AnimatedIconSwap.icon] changes.
class _AnimatedIconSwapState extends State<AnimatedIconSwap> {
  @override
  Widget build(BuildContext context) {
    final effectiveDuration =
        widget.duration ??
        FloatingTabBarThemeData.of(context).animationDuration;
    return AnimatedSwitcher(
      duration: effectiveDuration,
      child: Icon(
        widget.icon,
        key: ValueKey(widget.icon),
        size: widget.theme.size,
        color: widget.theme.color,
      ),
    );
  }
}
