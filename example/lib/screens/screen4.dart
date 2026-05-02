import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';

class Screen4 extends StatefulWidget {
  const Screen4({super.key});

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
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
    (icon: Icons.pets, activeIcon: Icons.pets, label: 'Big Cats'),
    (icon: Icons.eco_outlined, activeIcon: Icons.eco, label: 'Herbivores'),
    (icon: Icons.warning_rounded, activeIcon: Icons.warning, label: 'Reptiles'),
  ];

  static const _content = [
    [
      ('Lion', 'King of the jungle'),
      ('Cheetah', 'Fastest land animal'),
      ('Leopard', 'Spotted hunter'),
      ('Jaguar', 'American big cat'),
      ('Tiger', 'Largest cat species'),
      ('Cougar', 'Mountain cat'),
      ('Puma', 'Silent stalker'),
    ],
    [
      ('Elephant', 'Largest mammal'),
      ('Giraffe', 'Tallest animal'),
      ('Zebra', 'Striped horse'),
      ('Rhinoceros', 'Horned giant'),
      ('Hippopotamus', 'River dweller'),
      ('Buffalo', 'Horned cattle'),
      ('Wildebeest', 'Migration master'),
      ('Antelope', 'Swift runner'),
      ('Gazelle', 'Graceful leaper'),
    ],
    [
      ('Crocodile', 'Ancient predator'),
      ('Python', 'Massive snake'),
      ('Mamba', 'Venomous killer'),
      ('Cobra', 'Hooded serpent'),
      ('Turtle', 'Armored reptile'),
      ('Komodo Dragon', 'Giant lizard'),
      ('Iguana', 'Colorful climber'),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final items = _content[_controller.selectedTabIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab bar with action button'),
        centerTitle: true,
      ),
      extendBody: true,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(items[i].$1),
          subtitle: Text(items[i].$2),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FloatingTabBar(
          controller: _controller,
          segments: [
            FloatingTabsSegment(
              layout: FloatingTabsLayout.intrinsic,
              alignment: FloatingSegmentAlignment.start,
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
            FloatingActionSegment(
              alignment: FloatingSegmentAlignment.end,
              buttons: [
                ActionButton(icon: Icons.crisis_alert, onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
