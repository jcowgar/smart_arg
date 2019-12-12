/// Argument group annotation
class Group {
  /// Name of the group
  final String name;

  /// Text to display after the group header but before the argument list.
  final String beforeHelp;

  /// Text to display after the argument list.
  final String afterHelp;

  const Group({this.name, this.beforeHelp, this.afterHelp});
}
