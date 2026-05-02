# Flutter widget Tab Bar that mimics new iOS 26 liquid tab bar

Floating tab bar consists of two rows of segments (pills). No glass effects, only blur.
Fills maximum available horizontal space (can be limited by parent widget).
No external dependencies.

## Rows

Top row (accessory) is for an accessory segments only and bottom row (main) is for any types of segments.
Top row is optional and visible only if accessory segment added in proper state.
Accessory row can be only one height - 48 px, Main row can be two different heights: expanded - 68 px and compact - 48
px. These heights are actually segment pills height. Rows separated by vertical spacing.

## States

Tab bar can be in three states:

- Expanded. Full size (68) of main row, labels visible. Default state (scroll up).
- Compact. Labels fade out, icons only, height 48. Scroll down >80px
- Minimized. Collapses to single floating circle pill showing only active icon from tabs segment. height 48, Scroll
  down >200px.

## Segments

Segments are pills separated from each other by horizontal spacing. Border radius for pills is a half of its height (
calculated). Each segment type could be added only once in tab bar, except action segment.
Segments have alignment in the row:

- Start
- Center
- End

### Action segment

Contains one or more simple action buttons (icon only). If one button only then it's a circle shape pill.
It should support hero animations.

### Options segment

Contains one icon button with circle shape. On tap of the icon button it expands to size of contained widget (must
respect maximum free space in the row) and shows additional widget to the right of the icon.
Tap on main icon collapses options segment to icon button.
Additional widget can handle its own taps. Options segment should support hero animations.

### Tabs segment

Contains tab icons to switch between app routes. Can be collapsed to selected tab only. When collapsed it's a circle
shape pill. Tap on collapsed icon is a custom handler.
Contain active tab pill that can be dragged by user to select active tab with snap to the closest tab.
Active tab pill move should be animated if simply tapped on another tab. Active tab pill corner radius is a half of pill
height (calculated).
Tabs segment can be loose or wide. Loose is a compact view where tabs aligned to left with minimum tab width (equal
size). In loose state segment view does not fill all free space of the row.
Wide is an expanded segment view to fill rest of the free space in the row where tabs even spread across segment pill.
Active tab can have different icon, icon style and text style.

### Search segment

Have three states:

- Button. Looks like action segment. On tap expands to Expanded state.
- Expanded. Shows search icon, hint and optional mic icon. Expands to fill rest of free space in the
  row.
- Input. Shows search icon, text input with hint and optional mic icon. This state should ensure that
  search segment placed on top the onscreen keyboard if it's visible. Expands to fill rest of free space in the row.

### Accessory segment

Pill with any provided widget. Fills all free space in the row.
Have two states:

- Separate. Shows in top row.
- Inline. Shows in main row.

## Animations

All animations of parts of widget should be synchronized between each other.
Every segment pill resize or content change should be animated.
Search pill transform and move must be animated.
Icon swap in any segments should be animated.
Text style changes should be animated.
Tabs segment label fade on collapse.
Accessory segment movement and resize from top row to main row and vice versa must be animated.

## Theming

All themable parameters must have overridable default values.

Themable parameters:

- Tab bar expanded height
- Tab bar compact height
- Segment Pill background
- Segment Pill border
- Segment Pill blur
- Segment horizontal spacing
- Segment vertical spacing
- Tab icon
- Tab active icon
- Tab label
- Tab active label
- Tab pill color
- Tab pill border
- Action segment icon
- Option segment active icon
- Search icon/Mic icon
- Search hint
- Search input text
- Animation durations

# Not in scope

- Scroll integration