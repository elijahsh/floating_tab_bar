import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';

class Screen10 extends StatefulWidget {
  const Screen10({super.key});

  @override
  State<Screen10> createState() => _Screen10State();
}

class _Screen10State extends State<Screen10> {
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
        title: const Text('Screen 10'),
        centerTitle: true,
      ),
      extendBody: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.black26,
          child: const Column(
            children: [
              ListTile(title: Text('Mercury'), subtitle: Text('Closest to Sun')),
              ListTile(title: Text('Venus'), subtitle: Text('Hottest planet')),
              ListTile(title: Text('Earth'), subtitle: Text('Our planet')),
              ListTile(title: Text('Mars'), subtitle: Text('Red planet')),
              ListTile(title: Text('Jupiter'), subtitle: Text('Largest planet')),
              ListTile(title: Text('Saturn'), subtitle: Text('Ringed planet')),
              ListTile(title: Text('Uranus'), subtitle: Text('Ice giant')),
              ListTile(title: Text('Neptune'), subtitle: Text('Windy giant')),
              ListTile(title: Text('Moon'), subtitle: Text('Earth satellite')),
              ListTile(title: Text('Sun'), subtitle: Text('Star')),
              ListTile(title: Text('Sirius'), subtitle: Text('Brightest star')),
              ListTile(title: Text('Polaris'), subtitle: Text('North star')),
              ListTile(title: Text('Betelgeuse'), subtitle: Text('Red supergiant')),
              ListTile(title: Text('Rigel'), subtitle: Text('Blue star')),
              ListTile(title: Text('Andromeda'), subtitle: Text('Galaxy')),
              ListTile(title: Text('Milky Way'), subtitle: Text('Our galaxy')),
              ListTile(title: Text('Black Hole'), subtitle: Text('Cosmic object')),
              ListTile(title: Text('Nebula'), subtitle: Text('Gas cloud')),
              ListTile(title: Text('Comet'), subtitle: Text('Icy body')),
              ListTile(title: Text('Asteroid'), subtitle: Text('Rocky object')),
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
