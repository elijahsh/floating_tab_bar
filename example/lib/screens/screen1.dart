import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
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
    _controller.tabsCollapsed = true;
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
        _controller.tabsCollapsed = true;
        _controller.accessoryPlacement = FloatingAccessoryPlacement.inline;
      }
    } else {
      _delta = (_delta > 0 ? 0 : _delta) + d;
      if (_delta <= -_compactThreshold / 2 &&
          _controller.state != FloatingTabBarState.expanded) {
        _controller.tabsCollapsed = false;
        _controller.setState(FloatingTabBarState.expanded);
        _controller.accessoryPlacement = FloatingAccessoryPlacement.separate;
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
      appBar: AppBar(title: const Text('Accessory example'), centerTitle: true),
      extendBody: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.black26,
          child: const Column(
            children: [
              ListTile(title: Text('Item 1'), subtitle: Text('Subtitle 1')),
              ListTile(title: Text('Item 2'), subtitle: Text('Subtitle 2')),
              ListTile(title: Text('Item 3'), subtitle: Text('Subtitle 3')),
              ListTile(title: Text('Item 4'), subtitle: Text('Subtitle 4')),
              ListTile(title: Text('Item 5'), subtitle: Text('Subtitle 5')),
              ListTile(title: Text('Item 6'), subtitle: Text('Subtitle 6')),
              ListTile(title: Text('Item 7'), subtitle: Text('Subtitle 7')),
              ListTile(title: Text('Item 8'), subtitle: Text('Subtitle 8')),
              ListTile(title: Text('Item 9'), subtitle: Text('Subtitle 9')),
              ListTile(title: Text('Item 10'), subtitle: Text('Subtitle 10')),
              ListTile(title: Text('Item 11'), subtitle: Text('Subtitle 11')),
              ListTile(title: Text('Item 12'), subtitle: Text('Subtitle 12')),
              ListTile(title: Text('Item 13'), subtitle: Text('Subtitle 13')),
              ListTile(title: Text('Item 14'), subtitle: Text('Subtitle 14')),
              ListTile(title: Text('Item 15'), subtitle: Text('Subtitle 15')),
              ListTile(title: Text('Item 16'), subtitle: Text('Subtitle 16')),
              ListTile(title: Text('Item 17'), subtitle: Text('Subtitle 17')),
              ListTile(title: Text('Item 18'), subtitle: Text('Subtitle 18')),
              ListTile(title: Text('Item 19'), subtitle: Text('Subtitle 19')),
              ListTile(title: Text('Item 20'), subtitle: Text('Subtitle 20')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FloatingTabBar(
          controller: _controller,
          segments: [
            FloatingTabsSegment(
              layout: FloatingTabsLayout.intrinsic,
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Accessory'),
              ),
            ),
            FloatingActionSegment(
              alignment: FloatingSegmentAlignment.end,
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
