import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';

class Screen5 extends StatefulWidget {
  const Screen5({super.key});

  @override
  State<Screen5> createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {
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
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab bar with Accessory segment'),
        centerTitle: true,
      ),
      extendBody: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.black26,
          child: const Column(
            children: [
              ListTile(title: Text('Python'), subtitle: Text('General purpose')),
              ListTile(title: Text('JavaScript'), subtitle: Text('Web language')),
              ListTile(title: Text('Java'), subtitle: Text('Object oriented')),
              ListTile(title: Text('C++'), subtitle: Text('Systems language')),
              ListTile(title: Text('C#'), subtitle: Text('.NET platform')),
              ListTile(title: Text('Ruby'), subtitle: Text('Dynamic language')),
              ListTile(title: Text('PHP'), subtitle: Text('Web backend')),
              ListTile(title: Text('Go'), subtitle: Text('Compiled language')),
              ListTile(title: Text('Rust'), subtitle: Text('Memory safe')),
              ListTile(title: Text('Kotlin'), subtitle: Text('JVM language')),
              ListTile(title: Text('Swift'), subtitle: Text('Apple platform')),
              ListTile(title: Text('TypeScript'), subtitle: Text('Typed JavaScript')),
              ListTile(title: Text('Scala'), subtitle: Text('Functional JVM')),
              ListTile(title: Text('Haskell'), subtitle: Text('Functional language')),
              ListTile(title: Text('Clojure'), subtitle: Text('Lisp dialect')),
              ListTile(title: Text('R'), subtitle: Text('Statistical language')),
              ListTile(title: Text('MATLAB'), subtitle: Text('Numerical computing')),
              ListTile(title: Text('Perl'), subtitle: Text('Text processing')),
              ListTile(title: Text('Groovy'), subtitle: Text('Dynamic JVM')),
              ListTile(title: Text('Lua'), subtitle: Text('Lightweight script')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FloatingTabBar(
          controller: _controller,
          segments: [
            FloatingTabsSegment(
              tabs: [
                FloatingTab(
                  icon: Icons.visibility_off,
                  activeIcon: Icons.visibility,
                  label: 'Visibility',
                ),
                FloatingTab(
                  icon: Icons.visibility_off,
                  activeIcon: Icons.visibility,
                  label: 'Visibility',
                ),
                FloatingTab(
                  icon: Icons.visibility_off,
                  activeIcon: Icons.visibility,
                  label: 'Visibility',
                ),
              ],
            ),
            FloatingAccessorySegment(
              child: Text('Accessory'),
            ),
            FloatingActionSegment(
              buttons: [
                ActionButton(icon: Icons.search, onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
