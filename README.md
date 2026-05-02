# Floating Tab Bar

A Flutter widget for building a floating, animated tab bar from composable pill
segments. It supports tabs, search, action buttons, expandable options, and
custom accessory content while keeping the bar state controlled from your app.

## Features

- Floating pill-based navigation bar with blur, border, and active tab styling.
- Three bar states: expanded, compact, and minimized.
- Controller-driven tab selection, search state, options expansion, and accessory
  placement.
- Composable segments:
  - `FloatingTabsSegment` for app navigation tabs.
  - `FloatingSearchSegment` for button, expanded, and input search states.
  - `FloatingActionSegment` for one or more icon actions.
  - `FloatingOptionsSegment` for an expandable custom widget.
  - `FloatingAccessorySegment` for inline or separate custom content.
- Flexible or intrinsic tab layouts.
- Theme extension for sizes, colors, typography, blur, spacing, and animation.
- No runtime dependencies outside Flutter.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  floating_tab_bar:
    git:
      url: https://github.com/elijahsh/floating_tab_bar
```

Then import it:

```dart
import 'package:floating_tab_bar/floating_tab_bar.dart';
```

## Basic Usage

Create a `FloatingTabBarController`, keep it alive for the lifetime of the bar,
and place `FloatingTabBar` where you want the floating navigation to appear.

```dart
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FloatingTabBarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FloatingTabBarController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: Center(child: Text('Page content')),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingTabBar(
              controller: _controller,
              segments: [
                FloatingTabsSegment(
                  layout: FloatingTabsLayout.flexible,
                  tabs: const [
                    FloatingTab(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: 'Home',
                    ),
                    FloatingTab(
                      icon: Icons.search_outlined,
                      activeIcon: Icons.search,
                      label: 'Search',
                    ),
                    FloatingTab(
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: 'Profile',
                    ),
                  ],
                ),
                FloatingActionSegment(
                  buttons: [
                    ActionButton(
                      icon: Icons.add_rounded,
                      onTap: () {
                        // Handle action.
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

Listen to the controller if your page should react when the selected tab changes:

```dart
controller.addListener(() {
  final tabIndex = controller.selectedTabIndex;
  final query = controller.searchQuery;
});
```

## Search

`FloatingSearchSegment` can act as a search button, expanded search prompt, or
active text input. The controller owns the search text controller by default.

```dart
FloatingTabBar(
  controller: controller,
  segments: const [
    FloatingTabsSegment(
      tabs: [
        FloatingTab(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
        ),
      ],
    ),
    FloatingSearchSegment(
      hint: 'Search',
      showMic: true,
    ),
  ],
)
```

Useful controller methods and properties:

- `controller.searchState = FloatingSearchState.input`
- `controller.searchTextController`
- `controller.searchQuery`
- `autoCollapseTabsOnSearch`
- `autoCompactBarOnSearch`

## Options And Accessory Segments

Use `FloatingOptionsSegment` when an icon should reveal extra controls in the
same row. Use `FloatingAccessorySegment` for larger custom content that can live
in a separate top row or inline with the main row.

```dart
FloatingTabBar(
  controller: controller,
  segments: [
    const FloatingTabsSegment(
      tabs: [
        FloatingTab(
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard,
          label: 'Board',
        ),
      ],
    ),
    FloatingOptionsSegment(
      icon: Icons.tune_rounded,
      expandedChild: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.sort_rounded),
          SizedBox(width: 8),
          Text('Sort'),
        ],
      ),
    ),
    const FloatingAccessorySegment(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('Accessory content'),
      ),
    ),
  ],
)
```

The controller exposes:

- `controller.toggleOptions()`
- `controller.optionsExpanded`
- `controller.accessoryPlacement = FloatingAccessoryPlacement.inline`
- `controller.accessoryPlacement = FloatingAccessoryPlacement.separate`

## Theming

`FloatingTabBarThemeData` is a Flutter `ThemeExtension`. Add it to your app
theme or pass a theme directly to the widget.

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const [
      FloatingTabBarThemeData(),
    ],
  ),
  home: const HomePage(),
)
```

Override specific values with `copyWith`:

```dart
FloatingTabBar(
  controller: controller,
  theme: FloatingTabBarThemeData.defaults.copyWith(
    expandedHeight: 72,
    compactHeight: 52,
    pillBackgroundColor: const Color(0xCCFFFFFF),
    activeTabPillColor: const Color(0x22007AFF),
    animationDuration: const Duration(milliseconds: 300),
  ),
  segments: const [
    // Segments...
  ],
)
```

## Example App

Run the included example to see combinations of tabs, search, action buttons,
options, and accessory segments:

```sh
cd example
flutter run
```

## Notes

- At most one tabs, search, options, and accessory segment can be added to a bar.
  Multiple action segments are supported.
- In minimized state the bar collapses to the selected tab icon.
- When search is in input mode, the search segment is shown on its own and is
  padded above the onscreen keyboard.
