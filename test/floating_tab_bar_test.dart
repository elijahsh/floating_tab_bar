import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:liquid_tab_bar/floating_tab_bar.dart';
import 'package:liquid_tab_bar/src/rendering/action_segment_view.dart';
import 'package:liquid_tab_bar/src/rendering/search_segment_view.dart';
import 'package:liquid_tab_bar/src/rendering/tabs_segment_view.dart';

void main() {
  testWidgets('collapsed loose tabs are circular in compact state', (
    tester,
  ) async {
    final controller = FloatingTabBarController(
      initialState: FloatingTabBarState.compact,
    )..tabsCollapsed = true;
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomLeft,
            child: FloatingTabBar(
              controller: controller,
              theme: FloatingTabBarThemeData.defaults.copyWith(
                animationDuration: Duration.zero,
                tabBarPadding: EdgeInsets.zero,
              ),
              segments: const [
                FloatingTabsSegment(
                  layout: FloatingTabsLayout.intrinsic,
                  tabs: [
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final clip = find.descendant(
      of: find.byType(TabsSegmentView),
      matching: find.byType(ClipRect),
    );

    expect(tester.getSize(clip.first), const Size(48, 48));
  });

  testWidgets('minimized tabs render the collapsed tabs segment', (
    tester,
  ) async {
    final controller = FloatingTabBarController(
      initialState: FloatingTabBarState.minimized,
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomLeft,
            child: FloatingTabBar(
              controller: controller,
              theme: FloatingTabBarThemeData.defaults.copyWith(
                animationDuration: Duration.zero,
                tabBarPadding: EdgeInsets.zero,
              ),
              segments: const [
                FloatingTabsSegment(
                  layout: FloatingTabsLayout.intrinsic,
                  tabs: [
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final segment = find.byType(TabsSegmentView);
    expect(segment, findsOneWidget);

    final clip = find.descendant(of: segment, matching: find.byType(ClipRect));
    expect(tester.getSize(clip.first), const Size(48, 48));
  });

  testWidgets('search button tap collapses tabs during the same animation', (
    tester,
  ) async {
    const duration = Duration(milliseconds: 400);
    final controller = FloatingTabBarController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 360,
              child: FloatingTabBar(
                controller: controller,
                theme: FloatingTabBarThemeData.defaults.copyWith(
                  animationDuration: duration,
                  tabBarPadding: EdgeInsets.zero,
                ),
                segments: const [
                  FloatingTabsSegment(
                    layout: FloatingTabsLayout.flexible,
                    tabs: [
                      FloatingTab(
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home,
                        label: 'Home',
                      ),
                      FloatingTab(
                        icon: Icons.favorite_border,
                        activeIcon: Icons.favorite,
                        label: 'Likes',
                      ),
                      FloatingTab(
                        icon: Icons.person_outline,
                        activeIcon: Icons.person,
                        label: 'Profile',
                      ),
                    ],
                  ),
                  FloatingSearchSegment(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final tabs = find.byType(TabsSegmentView);
    final search = find.byType(SearchSegmentView);
    final initialTabsWidth = tester.getSize(tabs).width;
    final initialSearchWidth = tester.getSize(search).width;

    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pump();
    await tester.pump(duration ~/ 2);

    expect(controller.tabsCollapsed, isTrue);
    expect(tester.getSize(tabs).width, lessThan(initialTabsWidth));
    expect(tester.getSize(search).width, greaterThan(initialSearchWidth));
  });

  testWidgets('input search shows only search and embedded close action', (
    tester,
  ) async {
    final controller = FloatingTabBarController(
      initialSearchState: FloatingSearchState.input,
    );
    addTearDown(controller.dispose);

    var closed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 360,
              child: FloatingTabBar(
                controller: controller,
                theme: FloatingTabBarThemeData.defaults.copyWith(
                  animationDuration: Duration.zero,
                  tabBarPadding: EdgeInsets.zero,
                ),
                segments: [
                  const FloatingTabsSegment(
                    layout: FloatingTabsLayout.flexible,
                    tabs: [
                      FloatingTab(
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home,
                        label: 'Home',
                      ),
                    ],
                  ),
                  FloatingActionSegment(
                    buttons: [
                      ActionButton(icon: Icons.add_rounded, onTap: () {}),
                    ],
                  ),
                  FloatingSearchSegment(
                    closeIcon: Icons.cancel_rounded,
                    onCloseTap: () {
                      closed = true;
                      controller.searchState = FloatingSearchState.button;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(TabsSegmentView), findsNothing);
    expect(find.byIcon(Icons.add_rounded), findsNothing);
    expect(find.byType(SearchSegmentView), findsOneWidget);

    final embeddedCloseAction = find.descendant(
      of: find.byType(SearchSegmentView),
      matching: find.byType(ActionSegmentView),
    );
    expect(embeddedCloseAction, findsOneWidget);
    expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.cancel_rounded));
    await tester.pump();

    expect(closed, isTrue);
    expect(controller.searchState, FloatingSearchState.button);
  });

  testWidgets('expanded and input search states switch immediately', (
    tester,
  ) async {
    const duration = Duration(milliseconds: 400);
    final controller = FloatingTabBarController(
      initialState: FloatingTabBarState.compact,
      initialSearchState: FloatingSearchState.expanded,
      autoCompactBarOnSearch: false,
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 360,
              child: FloatingTabBar(
                controller: controller,
                theme: FloatingTabBarThemeData.defaults.copyWith(
                  animationDuration: duration,
                  tabBarPadding: EdgeInsets.zero,
                ),
                segments: const [
                  FloatingSearchSegment(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    controller.searchState = FloatingSearchState.input;
    await tester.pump();

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(controller.searchState, FloatingSearchState.expanded);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('search hint keeps the same position when input opens', (
    tester,
  ) async {
    const hint = 'Find widgets';
    final controller = FloatingTabBarController(
      initialState: FloatingTabBarState.compact,
      initialSearchState: FloatingSearchState.expanded,
      autoCompactBarOnSearch: false,
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 360,
              child: FloatingTabBar(
                controller: controller,
                theme: FloatingTabBarThemeData.defaults.copyWith(
                  animationDuration: Duration.zero,
                  tabBarPadding: EdgeInsets.zero,
                ),
                segments: const [
                  FloatingSearchSegment(hint: hint),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final expandedHintTopLeft = tester.getTopLeft(find.text(hint));

    controller.searchState = FloatingSearchState.input;
    await tester.pump();

    expect(tester.getTopLeft(find.text(hint)), expandedHintTopLeft);
  });
}
