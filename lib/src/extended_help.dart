/// Additional help with an optional header to be placed at the bottom of the usage.
///
/// See [Parser.extendedHelp].
class ExtendedHelp {
  /// Help text
  final String? help;

  /// Optional header text.
  ///
  /// If the header text is given, a section header will be created and the
  /// help text will appear indented by 2 spaces under the section header.
  final String? header;

  const ExtendedHelp(this.help, {this.header});
}
