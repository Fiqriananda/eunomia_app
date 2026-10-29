import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG Icon definitions satisfying the strict constraint:
/// "Without raw icon must SVG"
class AppSvgIcons {

  // Shield / Admin
  static const String shield = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 22C12 22 20 18 20 12V5L12 2L4 5V12C4 18 12 22 12 22Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 12L11 14L15 10" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Chart / Performance Analytics
  static const String chart = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M18 20V10M12 20V4M6 20V14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Trophy / Rank Award
  static const String trophy = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M6 9H4C2.9 9 2 8.1 2 7V5C2 3.9 2.9 3 4 3H6M18 9H20C21.1 9 22 8.1 22 7V5C22 3.9 21.1 3 20 3H18M6 3H18V10C18 13.3 15.3 16 12 16C8.7 16 6 13.3 6 10V3ZM12 16V20M8 21H16" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Trending Up
  static const String trendingUp = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <polyline points="23 6 13.5 15.5 8.5 10.5 1 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <polyline points="17 6 23 6 23 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Linear Logo
  static const String eunomiaLogo = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 80 80" fill="none">
  <path d="M 14.0 21.0 L 31.5 46.5 L 46.0 38.0 L 54.0 50.5 L 29.0 69.0 L 1.0 30.0 Z" fill="#FFB45D"/>
  <path d="M 65.0 58.0 L 47.5 32.5 L 33.0 41.0 L 25.0 28.5 L 50.0 10.0 L 78.0 49.0 Z" fill="#FFB45D"/>
</svg>
''';

  // Navigation: Home
  static const String navHome = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="7" height="18" rx="2" stroke="currentColor" stroke-width="1.8"/>
  <rect x="14" y="9" width="7" height="12" rx="2" stroke="currentColor" stroke-width="1.8"/>
  <path d="M6.5 7V17M17.5 13V17" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
</svg>
''';

  // Navigation: Tasks
  static const String navTasks = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.8"/>
  <path d="M8.5 12L10.8 14.5L15.5 9.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Navigation: Inbox
  static const String navInbox = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M4 4H20V15C20 16.1 19.1 17 18 17H15.5C14.7 17 14 17.7 14 18.5V19C14 19.6 13.6 20 13 20H11C10.4 20 10 19.6 10 19V18.5C10 17.7 9.3 17 8.5 17H6C4.9 17 4 16.1 4 15V4Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M3 13H8L10 16H14L16 13H21" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Navigation: Activity
  static const String navActivity = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 12H6.5L9.5 5L14.5 19L17.5 12H21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="9.5" cy="5" r="1.5" fill="currentColor"/>
  <circle cx="14.5" cy="19" r="1.5" fill="currentColor"/>
</svg>
''';

  // Linear: My Issues (Focus target crosshair)
  static const String myIssues = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M5 8V6C5 5.44772 5.44772 5 6 5H8M16 5H18C18.5523 5 19 5.44772 19 6V8M19 16V18C19 18.5523 18.5523 19 18 19H16M8 19H6C5.44772 19 5 18.5523 5 18V16" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="12" cy="12" r="3.2" fill="currentColor"/>
</svg>
''';

  // Linear: Pulse (Lightning bolt)
  static const String pulse = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M13 2.5L4 13.5H11.5L10.5 21.5L19.5 10.5H12L13 2.5Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Linear: Switch / Cycles (Double chevron up-down)
  static const String switchCycles = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M7 14.5L12 19.5L17 14.5M7 9.5L12 4.5L17 9.5" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Linear: Create Issue / Action (Squircle Compose)
  static const String createIssue = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 4H6C4.89543 4 4 4.89543 4 6V18C4 19.1046 4.89543 20 6 20H18C19.1046 20 20 19.1046 20 18V12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M18.5 2.5C19.3284 1.67157 20.6716 1.67157 21.5 2.5C22.3284 3.32843 22.3284 4.67157 21.5 5.5L12 15L8 16L9 12L18.5 2.5Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Star / Favorites
  static const String star = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Cube / Projects
  static const String cube = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M21 16V8L12 3L3 8V16L12 21L21 16Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M3.27 6.96L12 12.01L20.73 6.96M12 22.08V12" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Layers / Views
  static const String layers = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M2 17L12 22L22 17M2 12L12 17L22 12" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Gear / Settings
  static const String gear = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.8"/>
  <path d="M19.4 15A1.65 1.65 0 0 0 19.73 16.82L19.82 16.91A2 2 0 1 1 17 19.73L16.91 19.64A1.65 1.65 0 0 0 15.09 19.4A1.65 1.65 0 0 0 14 20.94V21A2 2 0 1 1 10 21V20.91A1.65 1.65 0 0 0 8.91 19.37A1.65 1.65 0 0 0 7.09 19.7L7 19.79A2 2 0 1 1 4.18 16.97L4.27 16.88A1.65 1.65 0 0 0 4.6 15.06A1.65 1.65 0 0 0 3.06 14H3A2 2 0 1 1 3 10H3.09A1.65 1.65 0 0 0 4.63 8.91A1.65 1.65 0 0 0 4.3 7.09L4.21 7A2 2 0 1 1 7.03 4.18L7.12 4.27A1.65 1.65 0 0 0 8.94 4.6A1.65 1.65 0 0 0 10 3.06V3A2 2 0 1 1 14 3V3.09A1.65 1.65 0 0 0 15.09 4.63A1.65 1.65 0 0 0 16.91 4.3L17 4.21A2 2 0 1 1 19.82 7.03L19.73 7.12A1.65 1.65 0 0 0 19.4 8.94A1.65 1.65 0 0 0 20.94 10H21A2 2 0 1 1 21 14H20.91A1.65 1.65 0 0 0 19.4 15Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Bell / Notification
  static const String bell = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M18 8A6 6 0 0 0 6 8C6 15 3 17 3 17H21C21 17 18 15 18 8Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M13.73 21A2 2 0 0 1 10.27 21" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Plus / Add
  static const String plus = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 5V19M5 12H19" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Chevron Down
  static const String chevronDown = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M6 9L12 15L18 9" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Chevron Right
  static const String chevronRight = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Arrow Back
  static const String arrowBack = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M19 12H5M5 12L12 19M5 12L12 5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Search
  static const String search = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
  <path d="M16.5 16.5L21 21" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>
''';

  // Filter / Sliders
  static const String filter = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M4 6H20M7 12H17M10 18H14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>
''';

  // Checkmark
  static const String check = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M5 12.5L9.5 17L19 7" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Checkmark Circle Completed
  static const String checkCircle = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.8"/>
  <path d="M8.5 12L10.8 14.5L15.5 9.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Close / Cross
  static const String close = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M18 6L6 18M6 6L18 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // More Horizontal (...)
  static const String moreHoriz = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="5" cy="12" r="2" fill="currentColor"/>
  <circle cx="12" cy="12" r="2" fill="currentColor"/>
  <circle cx="19" cy="12" r="2" fill="currentColor"/>
</svg>
''';

  // Clock
  static const String clock = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.8"/>
  <path d="M12 7V12L15 14" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
</svg>
''';

  // Folder
  static const String folder = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 6C3 4.9 3.9 4 5 4H9.6C10.2 4 10.7 4.2 11.1 4.6L12.9 6.4C13.3 6.8 13.8 7 14.4 7H19C20.1 7 21 7.9 21 9V18C21 19.1 20.1 20 19 20H5C3.9 20 3 19.1 3 18V6Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Sync / Cycle
  static const String sync = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M21 12A9 9 0 0 0 6 5.3L3 8M3 3V8H8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M3 12A9 9 0 0 0 18 18.7L21 16M21 21V16H16" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Cloud Synced
  static const String cloudSynced = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M17.5 19H7C4.8 19 3 17.2 3 15C3 13 4.4 11.3 6.4 11.1C7 7.7 10 5 13.5 5C17.4 5 20.6 8 20.9 11.8C22.1 12.5 23 13.8 23 15.3C23 17.3 21.4 19 19.4 19H17.5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M10 12L12 14L15 10" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Gesture Swipe
  static const String swipeGesture = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M14 9V5A2 2 0 0 0 10 5V13L7.7 11.5A1.8 1.8 0 0 0 5.2 13.9L10 19.5C11 20.7 12.5 21.4 14.1 21.4H17C19.2 21.4 21 19.6 21 17.4V11A2 2 0 0 0 17 11V9" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M3 8L6 5L9 8" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Priority: Urgent (Star / Asterisk alert)
  static const String priorityUrgent = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 3V21M3 12H21M5.6 5.6L18.4 18.4M18.4 5.6L5.6 18.4" stroke="currentColor" stroke-width="2.6" stroke-linecap="round"/>
</svg>
''';

  // Priority: High (3 ascending bars)
  static const String priorityHigh = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="4" y="14" width="3.5" height="7" rx="1" fill="currentColor"/>
  <rect x="10.25" y="9" width="3.5" height="12" rx="1" fill="currentColor"/>
  <rect x="16.5" y="4" width="3.5" height="17" rx="1" fill="currentColor"/>
</svg>
''';

  // Priority: Medium (2 bars)
  static const String priorityMedium = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="5" y="14" width="4" height="7" rx="1" fill="currentColor"/>
  <rect x="13" y="9" width="4" height="12" rx="1" fill="currentColor"/>
</svg>
''';

  // Priority: Low (1 bar / dot)
  static const String priorityLow = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="9" y="15" width="6" height="6" rx="1.5" fill="currentColor"/>
</svg>
''';

  // Priority: No Priority (dashed circle or dot)
  static const String priorityNone = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="8" stroke="currentColor" stroke-width="1.8" stroke-dasharray="3 3"/>
</svg>
''';

  // Status: Backlog (dotted circle)
  static const String statusBacklog = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="8" stroke="currentColor" stroke-width="2" stroke-dasharray="3 3"/>
</svg>
''';

  // Status: Todo (empty circle)
  static const String statusTodo = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="8" stroke="currentColor" stroke-width="2"/>
</svg>
''';

  // Status: In Progress (half filled circle)
  static const String statusInProgress = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="8" stroke="currentColor" stroke-width="2"/>
  <path d="M12 4A8 8 0 0 1 12 20Z" fill="currentColor"/>
</svg>
''';

  // Status: Done (filled checkmark circle)
  static const String statusDone = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="9" fill="currentColor"/>
  <path d="M8 12.2L10.7 15L16 9" stroke="#FFFFFF" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Status: Canceled (circle with cross)
  static const String statusCanceled = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/>
  <path d="M8 8L16 16M16 8L8 16" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
</svg>
''';

  // Paperclip / Attachment
  static const String paperclip = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M21.4 11.1L12.2 20.3C10.1 22.4 6.7 22.4 4.6 20.3C2.5 18.2 2.5 14.8 4.6 12.7L13.8 3.5C15.2 2.1 17.5 2.1 18.9 3.5C20.3 4.9 20.3 7.2 18.9 8.6L10.4 17.1C9.7 17.8 8.6 17.8 7.9 17.1C7.2 16.4 7.2 15.3 7.9 14.6L15.7 6.8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Send / Up Arrow
  static const String send = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 19V5M5 12L12 5L19 12" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Thumbs Up
  static const String thumbsUp = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M7 10V21M7 10L11.5 3.5C12.3 3.5 13 4.2 13 5V9H19.5C20.6 9 21.5 9.9 21.4 21L19 21H7M7 10H3.5C2.7 10 2 10.7 2 11.5V19.5C2 20.3 2.7 21 3.5 21H7" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Pencil / Edit
  static const String pencil = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M17 3L21 7L7 21H3V17L17 3Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Copy
  static const String copy = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="9" y="9" width="11" height="11" rx="2" stroke="currentColor" stroke-width="1.8"/>
  <path d="M5 15H4C2.9 15 2 14.1 2 13V4C2 2.9 2.9 2 4 2H13C14.1 2 15 2.9 15 4V5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
</svg>
''';

  // Code Doc / Block
  static const String codeDoc = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M16 18L22 12L16 6M8 6L2 12L8 18" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Play
  static const String play = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <polygon points="6,4 20,12 6,20" fill="currentColor"/>
</svg>
''';

  // Snooze / Timer
  static const String snooze = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="8" stroke="currentColor" stroke-width="1.8"/>
  <path d="M10 9H14L10 15H14" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Checkbox Checked
  static const String checkboxChecked = '''
<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect width="20" height="20" rx="4" fill="#5E6AD2"/>
  <path d="M5.5 10.5L8.5 13.5L14.5 6.5" stroke="#FFFFFF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Checkbox Unchecked
  static const String checkboxUnchecked = '''
<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="0.75" y="0.75" width="18.5" height="18.5" rx="3.25" stroke="rgba(255, 255, 255, 0.25)" stroke-width="1.5"/>
</svg>
''';

  // Tag
  static const String tag = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M20.59 13.41L13.42 20.58C12.64 21.36 11.37 21.36 10.59 20.58L3.41 13.41C2.63 12.63 2.63 11.36 3.41 10.58L9.58 4.41C9.96 4.04 10.47 3.82 11 3.82H19C20.1 3.82 21 4.72 21 5.82V13.82C21 14.35 20.79 14.86 20.41 15.24" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="16.5" cy="8.5" r="1.5" fill="currentColor"/>
</svg>
''';

  // Blocked / Dependency
  static const String blocked = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.8"/>
  <path d="M5.5 5.5L18.5 18.5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
</svg>
''';

  // Exclamation Alert
  static const String alert = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 8V13M12 16.5H12.01" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"/>
</svg>
''';

  // Trash
  static const String trash = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 6H21M19 6V20C19 21.1 18.1 22 17 22H7C5.9 22 5 21.1 5 20V6M8 6V4C8 2.9 8.9 2 10 2H14C15.1 2 16 2.9 16 4V6" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M10 11V17M14 11V17" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
</svg>
''';

  // Restore
  static const String restore = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M3 12A9 9 0 1 0 6 5.3L3 8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M3 3V8H8" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M12 7V12L15 15" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
</svg>
''';

  // Kanban Board
  static const String board = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="4" width="5" height="16" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
  <rect x="10" y="4" width="5" height="11" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
  <rect x="17" y="4" width="5" height="14" rx="1.5" stroke="currentColor" stroke-width="1.8"/>
</svg>
''';

  // List View
  static const String list = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M8 6H21M8 12H21M8 18H21M3 6H3.01M3 12H3.01M3 18H3.01" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Users / Team
  static const String users = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M16 21V19C16 16.8 14.2 15 12 15H6C3.8 15 2 16.8 2 19V21" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="9" cy="7" r="4" stroke="currentColor" stroke-width="1.8"/>
  <path d="M22 21V19C22 17.3 20.8 15.9 19.3 15.3M16 3.3C17.3 4.2 18 5.6 18 7.2C18 8.8 17.3 10.2 16 11.1" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
</svg>
''';

  // Reaction / Smile
  static const String smile = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.8"/>
  <path d="M8 14C9.2 15.8 11.5 16.5 13.5 15.5C14.5 15 15.2 14.2 16 13" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
  <circle cx="9" cy="9.5" r="1.2" fill="currentColor"/>
  <circle cx="15" cy="9.5" r="1.2" fill="currentColor"/>
</svg>
''';

  // Mail / Email
  static const String mail = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="5" width="18" height="14" rx="2" stroke="currentColor" stroke-width="1.8"/>
  <path d="M3 7L12 13L21 7" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Lock
  static const String lock = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="5" y="11" width="14" height="10" rx="2" stroke="currentColor" stroke-width="1.8"/>
  <path d="M8 11V7C8 4.79 9.79 3 12 3C14.21 3 16 4.79 16 7V11" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
  <circle cx="12" cy="16" r="1.5" fill="currentColor"/>
</svg>
''';

  // Eye
  static const String eye = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M1 12C1 12 5 4 12 4C19 4 23 12 23 12C23 12 19 20 12 20C5 20 1 12 1 12Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.8"/>
</svg>
''';

  // Eye Off
  static const String eyeOff = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20C5 20 1 12 1 12C2.24 9.69 4.35 7.77 6.94 6.66M9.9 4.24A9.12 9.12 0 0 1 12 4C19 4 23 12 23 12C21.84 14.16 20.02 15.98 17.76 17.06" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M1 1L23 23" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
  <path d="M14.12 14.12A3 3 0 0 1 9.88 9.88" stroke="currentColor" stroke-width="1.8"/>
</svg>
''';

  // User
  static const String user = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M20 21V19C20 16.79 18.21 15 16 15H8C5.79 15 4 16.79 4 19V21" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="12" cy="7" r="4" stroke="currentColor" stroke-width="1.8"/>
</svg>
''';

  // Log In
  static const String logIn = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M15 3H19C20.1 3 21 3.9 21 5V19C21 20.1 20.1 21 19 21H15" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M10 17L15 12L10 7M15 12H3" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Log Out
  static const String logOut = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 21H5C3.9 21 3 20.1 3 19V5C3 3.9 3.9 3 5 3H9" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M16 17L21 12L16 7M21 12H9" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';
}

/// Generic SVG Icon Widget matching the strictly SVG rule
class AppSvg extends StatelessWidget {
  final String svgString;
  final double size;
  final Color? color;

  const AppSvg(
    this.svgString, {
    super.key,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      svgString,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
