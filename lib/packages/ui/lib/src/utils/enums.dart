/// Describes the type of icon that can be used in LMChatIcon
///
/// [icon] - For using IconData icons
/// [svg] - For using SVG assets
/// [png] - For using PNG image assets
enum LMChatIconType {
  /// Uses IconData icons from Flutter's icon system
  icon,

  /// Uses SVG asset files
  svg,

  /// Uses PNG image files
  png,
}

/// Specifies the placement position of an icon within a button
///
/// [start] - Icon is placed at the start/beginning of the button
/// [end] - Icon is placed at the end of the button
enum LMChatIconButtonPlacement {
  /// Places icon at the start/beginning of the button
  start,

  /// Places icon at the end of the button
  end,
}

/// Defines different sorting/filtering options for exploring chatrooms
///
/// [newest] - Sort chatrooms by creation date (newest first)
/// [mostMessages] - Sort chatrooms by number of messages (highest first)
/// [mostParticipants] - Sort chatrooms by number of participants (highest first)
/// [active] - Show only active chatrooms
enum LMChatSpace {
  /// Sort chatrooms by creation date (newest first)
  newest,

  /// Sort chatrooms by number of messages (highest first)
  mostMessages,

  /// Sort chatrooms by number of participants (highest first)
  mostParticipants,

  /// Show only active chatrooms
  active,
}

/// Specifies the type of selection for a chatroom
///
/// [appbar] - Selection is done through the app bar
/// [floating] - Selection is done through a floating action button
/// [bottomsheet] - Selection is done through a bottom sheet
enum LMChatSelectionType {
  /// Selection is done through the app bar
  appbar,

  /// Selection is done through a floating action button
  floating,

  /// Selection is done through a bottom sheet
  bottomsheet,
}
