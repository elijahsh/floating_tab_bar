import 'dart:ui';

import 'package:flutter/material.dart';

/// Theme extension containing dimensions, colors, typography, and animation
/// values for [FloatingTabBar].
@immutable
class FloatingTabBarThemeData extends ThemeExtension<FloatingTabBarThemeData> {
  const FloatingTabBarThemeData({
    this.expandedHeight = 68.0,
    this.compactHeight = 48.0,
    this.tabBarPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.segmentsSpacing = 8.0,
    this.pillBlurSigma = 16.0,
    this.pillBackgroundColor = const Color(0xAAFFFFFF),
    this.pillBorder = const Border.fromBorderSide(
      BorderSide(color: Color(0x1A000000), width: 0.5),
    ),
    this.pillInnerPadding = 4.0,
    this.activeTabPillColor = const Color(0x1A000000),
    this.tabPadding = const EdgeInsets.symmetric(horizontal: 10),
    this.tabIconTheme = const IconThemeData(size: 24, color: Color(0xFF666666)),
    this.activeTabIconTheme = const IconThemeData(
      size: 24,
      color: Color(0xFF007AFF),
    ),
    this.tabIconLabelSpacing = 2.0,
    this.tabLabelStyle = const TextStyle(
      color: Color(0xFF666666),
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    this.tabActiveLabelStyle = const TextStyle(
      color: Color(0xFF007AFF),
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    this.searchIconTheme = const IconThemeData(
      size: 20,
      color: Color(0xFF666666),
    ),
    this.searchInputDecorationTheme = const InputDecorationTheme(
      hintStyle: TextStyle(
        fontSize: 15,
        color: Color(0xFF888888),
        fontWeight: FontWeight.w400,
      ),
    ),
    this.animationDuration = const Duration(milliseconds: 380),
    this.animationCurve = Curves.easeInOutCubic,
  });

  final double expandedHeight;
  final double compactHeight;
  final EdgeInsets tabBarPadding;
  final double segmentsSpacing;
  final double pillBlurSigma;
  final Color pillBackgroundColor;
  final BoxBorder pillBorder;
  final double pillInnerPadding;
  final Color activeTabPillColor;
  final EdgeInsets tabPadding;
  final IconThemeData tabIconTheme;
  final IconThemeData activeTabIconTheme;
  final double tabIconLabelSpacing;
  final TextStyle tabLabelStyle;
  final TextStyle tabActiveLabelStyle;
  final IconThemeData searchIconTheme;
  final InputDecorationTheme searchInputDecorationTheme;
  final Duration animationDuration;
  final Curve animationCurve;

  static const FloatingTabBarThemeData defaults = FloatingTabBarThemeData();

  static FloatingTabBarThemeData of(BuildContext context) =>
      Theme.of(context).extension<FloatingTabBarThemeData>() ?? defaults;

  @override
  FloatingTabBarThemeData copyWith({
    double? expandedHeight,
    double? compactHeight,
    EdgeInsets? tabBarPadding,
    double? segmentsSpacing,
    double? pillBlurSigma,
    Color? pillBackgroundColor,
    BoxBorder? pillBorder,
    double? pillInnerPadding,
    Color? activeTabPillColor,
    EdgeInsets? tabPadding,
    IconThemeData? tabIconTheme,
    IconThemeData? activeTabIconTheme,
    double? tabIconLabelSpacing,
    TextStyle? tabLabelStyle,
    TextStyle? tabActiveLabelStyle,
    IconThemeData? searchIconTheme,
    InputDecorationTheme? searchInputDecorationTheme,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return FloatingTabBarThemeData(
      expandedHeight: expandedHeight ?? this.expandedHeight,
      compactHeight: compactHeight ?? this.compactHeight,
      tabBarPadding: tabBarPadding ?? this.tabBarPadding,
      segmentsSpacing: segmentsSpacing ?? this.segmentsSpacing,
      pillBlurSigma: pillBlurSigma ?? this.pillBlurSigma,
      pillBackgroundColor: pillBackgroundColor ?? this.pillBackgroundColor,
      pillBorder: pillBorder ?? this.pillBorder,
      pillInnerPadding: pillInnerPadding ?? this.pillInnerPadding,
      activeTabPillColor: activeTabPillColor ?? this.activeTabPillColor,
      tabPadding: tabPadding ?? this.tabPadding,
      tabIconTheme: tabIconTheme ?? this.tabIconTheme,
      activeTabIconTheme: activeTabIconTheme ?? this.activeTabIconTheme,
      tabIconLabelSpacing: tabIconLabelSpacing ?? this.tabIconLabelSpacing,
      tabLabelStyle: tabLabelStyle ?? this.tabLabelStyle,
      tabActiveLabelStyle: tabActiveLabelStyle ?? this.tabActiveLabelStyle,
      searchIconTheme: searchIconTheme ?? this.searchIconTheme,
      searchInputDecorationTheme:
          searchInputDecorationTheme ?? this.searchInputDecorationTheme,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }

  @override
  FloatingTabBarThemeData lerp(FloatingTabBarThemeData? other, double t) {
    if (other == null) return this;
    return FloatingTabBarThemeData(
      expandedHeight: lerpDouble(expandedHeight, other.expandedHeight, t)!,
      compactHeight: lerpDouble(compactHeight, other.compactHeight, t)!,
      tabBarPadding: EdgeInsets.lerp(tabBarPadding, other.tabBarPadding, t)!,
      segmentsSpacing: lerpDouble(segmentsSpacing, other.segmentsSpacing, t)!,
      pillBlurSigma: lerpDouble(pillBlurSigma, other.pillBlurSigma, t)!,
      pillBackgroundColor: Color.lerp(
        pillBackgroundColor,
        other.pillBackgroundColor,
        t,
      )!,
      pillBorder: BoxBorder.lerp(pillBorder, other.pillBorder, t)!,
      pillInnerPadding: lerpDouble(
        pillInnerPadding,
        other.pillInnerPadding,
        t,
      )!,
      activeTabPillColor: Color.lerp(
        activeTabPillColor,
        other.activeTabPillColor,
        t,
      )!,
      tabPadding: EdgeInsets.lerp(tabPadding, other.tabPadding, t)!,
      tabIconTheme: t < 0.5 ? tabIconTheme : other.tabIconTheme,
      activeTabIconTheme: t < 0.5
          ? activeTabIconTheme
          : other.activeTabIconTheme,
      tabIconLabelSpacing: lerpDouble(
        tabIconLabelSpacing,
        other.tabIconLabelSpacing,
        t,
      )!,
      tabLabelStyle: TextStyle.lerp(tabLabelStyle, other.tabLabelStyle, t)!,
      tabActiveLabelStyle: TextStyle.lerp(
        tabActiveLabelStyle,
        other.tabActiveLabelStyle,
        t,
      )!,
      searchIconTheme: t < 0.5 ? searchIconTheme : other.searchIconTheme,
      searchInputDecorationTheme: t < 0.5
          ? searchInputDecorationTheme
          : other.searchInputDecorationTheme,
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
      animationCurve: t < 0.5 ? animationCurve : other.animationCurve,
    );
  }
}
