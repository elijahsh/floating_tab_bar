import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';

class Screen7 extends StatefulWidget {
  const Screen7({super.key});

  @override
  State<Screen7> createState() => _Screen7State();
}

class _Screen7State extends State<Screen7> {
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
        title: const Text('Screen 7'),
        centerTitle: true,
      ),
      extendBody: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.black26,
          child: const Column(
            children: [
              ListTile(title: Text('Pizza Margherita'), subtitle: Text('Italian classic')),
              ListTile(title: Text('Sushi'), subtitle: Text('Japanese rice')),
              ListTile(title: Text('Tacos'), subtitle: Text('Mexican street food')),
              ListTile(title: Text('Paella'), subtitle: Text('Spanish rice')),
              ListTile(title: Text('Curry'), subtitle: Text('Indian spiced')),
              ListTile(title: Text('Ramen'), subtitle: Text('Japanese noodles')),
              ListTile(title: Text('Pasta Carbonara'), subtitle: Text('Italian pasta')),
              ListTile(title: Text('Pad Thai'), subtitle: Text('Thai noodles')),
              ListTile(title: Text('Biryani'), subtitle: Text('Indian rice')),
              ListTile(title: Text('Pho'), subtitle: Text('Vietnamese soup')),
              ListTile(title: Text('Gyros'), subtitle: Text('Greek meat')),
              ListTile(title: Text('Falafel'), subtitle: Text('Middle Eastern')),
              ListTile(title: Text('Kebab'), subtitle: Text('Turkish roasted')),
              ListTile(title: Text('Crepes'), subtitle: Text('French pancakes')),
              ListTile(title: Text('Goulash'), subtitle: Text('Hungarian stew')),
              ListTile(title: Text('Fish Chips'), subtitle: Text('British fried')),
              ListTile(title: Text('Schnitzel'), subtitle: Text('German breaded')),
              ListTile(title: Text('Pierogi'), subtitle: Text('Polish dumplings')),
              ListTile(title: Text('Hummus'), subtitle: Text('Lebanese dip')),
              ListTile(title: Text('Baklava'), subtitle: Text('Turkish pastry')),
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
