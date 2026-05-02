import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';

class Screen9 extends StatefulWidget {
  const Screen9({super.key});

  @override
  State<Screen9> createState() => _Screen9State();
}

class _Screen9State extends State<Screen9> {
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
        title: const Text('Screen 9'),
        centerTitle: true,
      ),
      extendBody: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.black26,
          child: const Column(
            children: [
              ListTile(title: Text('Mountain Climbing'), subtitle: Text('Adventure')),
              ListTile(title: Text('Surfing'), subtitle: Text('Water sport')),
              ListTile(title: Text('Skydiving'), subtitle: Text('Extreme sport')),
              ListTile(title: Text('Rock Climbing'), subtitle: Text('Sport')),
              ListTile(title: Text('Scuba Diving'), subtitle: Text('Underwater')),
              ListTile(title: Text('Hiking'), subtitle: Text('Outdoor')),
              ListTile(title: Text('Kayaking'), subtitle: Text('Water sport')),
              ListTile(title: Text('Bungee Jumping'), subtitle: Text('Thrill seeking')),
              ListTile(title: Text('Base Jumping'), subtitle: Text('Extreme')),
              ListTile(title: Text('Paragliding'), subtitle: Text('Flying')),
              ListTile(title: Text('Caving'), subtitle: Text('Spelunking')),
              ListTile(title: Text('Zip Lining'), subtitle: Text('Aerial')),
              ListTile(title: Text('Snowboarding'), subtitle: Text('Winter sport')),
              ListTile(title: Text('Skiing'), subtitle: Text('Winter sport')),
              ListTile(title: Text('White Water Rafting'), subtitle: Text('Adventure')),
              ListTile(title: Text('Mountain Biking'), subtitle: Text('Cycling')),
              ListTile(title: Text('Rappelling'), subtitle: Text('Descending')),
              ListTile(title: Text('Windsurfing'), subtitle: Text('Water sport')),
              ListTile(title: Text('Kite Surfing'), subtitle: Text('Extreme sport')),
              ListTile(title: Text('Off-roading'), subtitle: Text('Vehicle sport')),
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
