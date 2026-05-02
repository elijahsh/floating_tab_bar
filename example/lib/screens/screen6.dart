import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';

class Screen6 extends StatefulWidget {
  const Screen6({super.key});

  @override
  State<Screen6> createState() => _Screen6State();
}

class _Screen6State extends State<Screen6> {
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
        title: const Text('Options with search'),
        centerTitle: true,
      ),
      extendBody: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.black26,
          child: const Column(
            children: [
              ListTile(title: Text('Paris'), subtitle: Text('France')),
              ListTile(title: Text('Tokyo'), subtitle: Text('Japan')),
              ListTile(title: Text('London'), subtitle: Text('England')),
              ListTile(title: Text('New York'), subtitle: Text('USA')),
              ListTile(title: Text('Sydney'), subtitle: Text('Australia')),
              ListTile(title: Text('Dubai'), subtitle: Text('UAE')),
              ListTile(title: Text('Barcelona'), subtitle: Text('Spain')),
              ListTile(title: Text('Rome'), subtitle: Text('Italy')),
              ListTile(title: Text('Amsterdam'), subtitle: Text('Netherlands')),
              ListTile(title: Text('Berlin'), subtitle: Text('Germany')),
              ListTile(title: Text('Bangkok'), subtitle: Text('Thailand')),
              ListTile(title: Text('Singapore'), subtitle: Text('Singapore')),
              ListTile(title: Text('Hong Kong'), subtitle: Text('China')),
              ListTile(title: Text('Istanbul'), subtitle: Text('Turkey')),
              ListTile(title: Text('Bangkok'), subtitle: Text('Thailand')),
              ListTile(title: Text('Madrid'), subtitle: Text('Spain')),
              ListTile(title: Text('Vienna'), subtitle: Text('Austria')),
              ListTile(title: Text('Prague'), subtitle: Text('Czech Republic')),
              ListTile(title: Text('Athens'), subtitle: Text('Greece')),
              ListTile(title: Text('Moscow'), subtitle: Text('Russia')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: FloatingTabBar(
          controller: _controller,
          segments: [
            FloatingOptionsSegment(
              icon: Icons.sort,
              expandedChild: Center(child: Text('Sorting')),
            ),
            FloatingActionSegment(
              alignment: FloatingSegmentAlignment.end,
              buttons: [ActionButton(icon: Icons.search, onTap: () {})],
            ),
          ],
        ),
      ),
    );
  }
}
