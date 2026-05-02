import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
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
        title: const Text('Simple with action'),
        centerTitle: true,
      ),
      extendBody: true,
      body: SingleChildScrollView(
        // controller: _scrollController,
        child: Container(
          color: Colors.black26,
          child: const Column(
            children: [
              ListTile(title: Text('Apple'), subtitle: Text('Red fruit')),
              ListTile(title: Text('Banana'), subtitle: Text('Yellow fruit')),
              ListTile(
                title: Text('Cherry'),
                subtitle: Text('Small red fruit'),
              ),
              ListTile(
                title: Text('Date'),
                subtitle: Text('Sweet brown fruit'),
              ),
              ListTile(
                title: Text('Elderberry'),
                subtitle: Text('Dark purple fruit'),
              ),
              ListTile(title: Text('Fig'), subtitle: Text('Sweet dried fruit')),
              ListTile(title: Text('Grape'), subtitle: Text('Clustered fruit')),
              ListTile(title: Text('Honeydew'), subtitle: Text('Green melon')),
              ListTile(
                title: Text('Kiwi'),
                subtitle: Text('Brown fuzzy fruit'),
              ),
              ListTile(title: Text('Lemon'), subtitle: Text('Yellow citrus')),
              ListTile(title: Text('Mango'), subtitle: Text('Tropical fruit')),
              ListTile(
                title: Text('Nectarine'),
                subtitle: Text('Smooth peach'),
              ),
              ListTile(title: Text('Orange'), subtitle: Text('Orange citrus')),
              ListTile(
                title: Text('Papaya'),
                subtitle: Text('Tropical yellow'),
              ),
              ListTile(
                title: Text('Quince'),
                subtitle: Text('Yellow pome fruit'),
              ),
              ListTile(title: Text('Raspberry'), subtitle: Text('Red berries')),
              ListTile(
                title: Text('Strawberry'),
                subtitle: Text('Red with seeds'),
              ),
              ListTile(
                title: Text('Tangerine'),
                subtitle: Text('Orange citrus'),
              ),
              ListTile(
                title: Text('Ugli Fruit'),
                subtitle: Text('Jamaican citrus'),
              ),
              ListTile(
                title: Text('Vanilla Bean'),
                subtitle: Text('Aromatic fruit'),
              ),
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
              alignment: FloatingSegmentAlignment.start,
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
              ],
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
