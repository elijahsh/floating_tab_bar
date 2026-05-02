import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  final _controller = FloatingTabBarController();
  final _scrollController = ScrollController();

  double _lastOffset = 0;
  double _delta = 0;

  static const double _compactThreshold = 80;
  static const double _minimizeThreshold = 200;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() => setState(() {});

  void _onScroll() {
    final offset = _scrollController.offset;
    final d = offset - _lastOffset;
    _lastOffset = offset;

    if (d > 0) {
      _delta = (_delta < 0 ? 0 : _delta) + d;
      if (_delta >= _minimizeThreshold &&
          _controller.state != FloatingTabBarState.minimized) {
        _controller.setState(FloatingTabBarState.minimized);
      } else if (_delta >= _compactThreshold &&
          _controller.state == FloatingTabBarState.expanded) {
        _controller.setState(FloatingTabBarState.compact);
      }
    } else {
      _delta = (_delta > 0 ? 0 : _delta) + d;
      if (_delta <= -_compactThreshold / 2 &&
          _controller.state != FloatingTabBarState.expanded) {
        _controller.setState(FloatingTabBarState.expanded);
        _delta = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  static const _tabs = [
    (
      icon: Icons.flutter_dash,
      activeIcon: Icons.flutter_dash,
      label: 'Flutter',
    ),
    (icon: Icons.code_outlined, activeIcon: Icons.code, label: 'Dart'),
    (icon: Icons.widgets_outlined, activeIcon: Icons.widgets, label: 'Widgets'),
  ];

  static const _content = [
    [
      ('Hot Reload', 'Sub-second refresh cycle'),
      ('Widget Tree', 'Composable UI hierarchy'),
      ('Skia / Impeller', 'Cross-platform renderer'),
      ('Platform Channels', 'Native code bridge'),
      ('DevTools', 'Profiling & inspection'),
      ('pub.dev', 'Package repository'),
      ('Material 3', 'Design system'),
      ('Cupertino', 'iOS-style widgets'),
      ('go_router', 'Declarative navigation'),
    ],
    [
      ('Null Safety', 'Sound null-safe type system'),
      ('Async / Await', 'First-class async support'),
      ('Isolates', 'Parallel execution model'),
      ('Extension Methods', 'Add APIs to existing types'),
      ('Records', 'Anonymous product types'),
      ('Patterns', 'Destructuring and matching'),
      ('Sealed Classes', 'Exhaustive type hierarchies'),
      ('Macros', 'Compile-time code generation'),
    ],
    [
      ('StatelessWidget', 'Immutable UI fragment'),
      ('StatefulWidget', 'Mutable with lifecycle'),
      ('InheritedWidget', 'Efficient ancestor data'),
      ('LayoutBuilder', 'Constraint-aware builds'),
      ('AnimatedBuilder', 'Rebuild on animation tick'),
      ('CustomPainter', 'Low-level 2D drawing'),
      ('RenderObject', 'Layout and painting node'),
      ('SlottedMultiChildLayout', 'Named child slots'),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final items = _content[_controller.selectedTabIndex];
    final query = _controller.searchQuery;
    final filtered = query.isEmpty
        ? items
        : items
            .where(
              (e) =>
                  e.$1.toLowerCase().contains(query.toLowerCase()) ||
                  e.$2.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab bar with search bar'),
        centerTitle: true,
      ),
      extendBody: true,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: filtered.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(filtered[i].$1),
          subtitle: Text(filtered[i].$2),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FloatingTabBar(
          controller: _controller,
          segments: [
            FloatingTabsSegment(
              layout: FloatingTabsLayout.flexible,
              tabs: _tabs
                  .map(
                    (t) => FloatingTab(
                      icon: t.icon,
                      activeIcon: t.activeIcon,
                      label: t.label,
                    ),
                  )
                  .toList(),
            ),
            FloatingSearchSegment(
              alignment: FloatingSegmentAlignment.end,
              hint: 'Search topics',
              showMic: false,
            ),
          ],
        ),
      ),
    );
  }
}
