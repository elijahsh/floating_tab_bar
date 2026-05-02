import 'package:flutter/widgets.dart';

import 'segments/segment.dart';

/// High-level size and presentation mode for the floating tab bar.
enum FloatingTabBarState { expanded, compact, minimized }

/// Coordinates mutable tab bar state and notifies listeners of visual changes.
class FloatingTabBarController extends ChangeNotifier {
  FloatingTabBarController({
    FloatingTabBarState initialState = FloatingTabBarState.expanded,
    int initialTabIndex = 0,
    FloatingSearchState initialSearchState = FloatingSearchState.button,
    bool initialOptionsExpanded = false,
    FloatingAccessoryPlacement initialAccessoryPlacement =
        FloatingAccessoryPlacement.separate,
    TextEditingController? searchTextController,
    this.autoCollapseTabsOnSearch = true,
    this.autoCompactBarOnSearch = true,
    this.autoExpandBarOnTabsCollapsedTap = true,
  }) : _state = initialState,
       _selectedTabIndex = initialTabIndex,
       _searchState = initialSearchState,
       _optionsExpanded = initialOptionsExpanded,
       _accessoryPlacement = initialAccessoryPlacement,
       _ownedTextController = searchTextController == null,
       _searchTextController = searchTextController ?? TextEditingController();

  /// Whether opening search should collapse the tab segment into a single pill.
  final bool autoCollapseTabsOnSearch;

  /// Whether opening search should compact an expanded bar.
  final bool autoCompactBarOnSearch;

  /// Whether tapping collapsed tabs should restore the expanded tab bar.
  final bool autoExpandBarOnTabsCollapsedTap;

  // Internal state
  FloatingTabBarState _state;
  int _selectedTabIndex;
  FloatingSearchState _searchState;
  bool _tabsCollapsed = false;
  bool _optionsExpanded;
  FloatingAccessoryPlacement _accessoryPlacement;
  final TextEditingController _searchTextController;
  final bool _ownedTextController;
  bool _notifying = false;

  // ── Bar layout ─────────────────────────────────────────────────────────────

  FloatingTabBarState get state => _state;

  void setState(FloatingTabBarState newState) {
    if (_state == newState) return;
    _state = newState;
    _notify();
  }

  void expand() => setState(FloatingTabBarState.expanded);

  void compact() => setState(FloatingTabBarState.compact);

  void minimize() => setState(FloatingTabBarState.minimized);

  // ── Tabs ───────────────────────────────────────────────────────────────────

  int get selectedTabIndex => _selectedTabIndex;

  set selectedTabIndex(int value) {
    if (_selectedTabIndex == value) return;
    _selectedTabIndex = value;
    _notify();
  }

  /// True when tabs should display in collapsed (pill) form.
  bool get tabsCollapsed => _tabsCollapsed;

  set tabsCollapsed(bool value) {
    if (_tabsCollapsed == value) return;
    _tabsCollapsed = value;
    _notify();
  }

  /// Called when the user taps the collapsed tabs pill.
  void onTabsCollapsedTap() {
    if (autoExpandBarOnTabsCollapsedTap) {
      _searchState = FloatingSearchState.button;
      _tabsCollapsed = false;
      _state = FloatingTabBarState.expanded;
      _notify();
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  FloatingSearchState get searchState => _searchState;

  set searchState(FloatingSearchState value) {
    if (_searchState == value) return;
    _searchState = value;
    _applySearchPolicies();
    _notify();
  }

  TextEditingController get searchTextController => _searchTextController;

  String get searchQuery => _searchTextController.text;

  void _applySearchPolicies() {
    if (_searchState != FloatingSearchState.button) {
      if (autoCollapseTabsOnSearch) _tabsCollapsed = true;
      if (autoCompactBarOnSearch && _state == FloatingTabBarState.expanded) {
        _state = FloatingTabBarState.compact;
      }
    } else {
      if (autoCollapseTabsOnSearch) _tabsCollapsed = false;
    }
  }

  // ── Options ────────────────────────────────────────────────────────────────

  bool get optionsExpanded => _optionsExpanded;

  set optionsExpanded(bool value) {
    if (_optionsExpanded == value) return;
    _optionsExpanded = value;
    _notify();
  }

  void toggleOptions() => optionsExpanded = !_optionsExpanded;

  // ── Accessory ──────────────────────────────────────────────────────────────

  FloatingAccessoryPlacement get accessoryPlacement => _accessoryPlacement;

  set accessoryPlacement(FloatingAccessoryPlacement value) {
    if (_accessoryPlacement == value) return;
    _accessoryPlacement = value;
    _notify();
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  void _notify() {
    if (_notifying) return;
    _notifying = true;
    notifyListeners();
    _notifying = false;
  }

  @override
  void dispose() {
    if (_ownedTextController) _searchTextController.dispose();
    super.dispose();
  }
}
