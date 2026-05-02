import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';

class Screen8 extends StatefulWidget {
  const Screen8({super.key});

  @override
  State<Screen8> createState() => _Screen8State();
}

class _Screen8State extends State<Screen8> {
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
        title: const Text('Screen 8'),
        centerTitle: true,
      ),
      extendBody: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.black26,
          child: const Column(
            children: [
              ListTile(title: Text('Instagram'), subtitle: Text('Photo sharing')),
              ListTile(title: Text('Twitter'), subtitle: Text('Microblogging')),
              ListTile(title: Text('Facebook'), subtitle: Text('Social network')),
              ListTile(title: Text('LinkedIn'), subtitle: Text('Professional')),
              ListTile(title: Text('TikTok'), subtitle: Text('Short videos')),
              ListTile(title: Text('Snapchat'), subtitle: Text('Stories')),
              ListTile(title: Text('YouTube'), subtitle: Text('Video platform')),
              ListTile(title: Text('Reddit'), subtitle: Text('News aggregation')),
              ListTile(title: Text('Discord'), subtitle: Text('Chat platform')),
              ListTile(title: Text('Telegram'), subtitle: Text('Messenger')),
              ListTile(title: Text('WhatsApp'), subtitle: Text('Messaging')),
              ListTile(title: Text('Slack'), subtitle: Text('Workspace chat')),
              ListTile(title: Text('Mastodon'), subtitle: Text('Social media')),
              ListTile(title: Text('Bluesky'), subtitle: Text('Twitter alternative')),
              ListTile(title: Text('Threads'), subtitle: Text('Meta platform')),
              ListTile(title: Text('Pixelfed'), subtitle: Text('Image sharing')),
              ListTile(title: Text('Lemmy'), subtitle: Text('Forum aggregator')),
              ListTile(title: Text('Kbin'), subtitle: Text('Magazine platform')),
              ListTile(title: Text('Matrix'), subtitle: Text('Chat network')),
              ListTile(title: Text('XMPP'), subtitle: Text('Message protocol')),
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
