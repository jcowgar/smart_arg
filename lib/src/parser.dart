import 'extended_help.dart';

/// Annotation to define [SmartArg] wide properties.
class Parser {
  /// Application description that is displayed in the help output.
  final String? description;

  /// Additional text to be displayed at the bottom of the help output.
  ///
  /// This can be multiline.
  ///
  /// See also [ExtendedHelp].
  final List<ExtendedHelp>? extendedHelp;

  /// Minimum number of extras that are required for your application.
  ///
  /// An extra is anything passed on the command line that is not an option.
  ///
  /// See also [maximumExtras].
  final int? minimumExtras;

  /// Maximum number of extras that are allowed for your application.
  ///
  /// An extra is anything passed on the command line that is not an option.
  ///
  /// See also [minimumExtras].
  final int? maximumExtras;

  /// Exit the application with an exit code of 1 if there are argument
  /// parsing errors.
  final bool exitOnFailure;

  /// If true, do not add any long parameters from the class properties.
  ///
  /// All long parameter names must be specified manually.
  final bool strict;

  /// If [argumentTerminator] is parsed, the rest of the arguments are
  /// considered extras.
  final String? argumentTerminator;

  /// Allow trailing argument?
  ///
  /// A trailing argument is an argument that occurs after the first 'extra.'
  /// In the following text, `--dry-run` and `--exit-on-failure` are trailing
  /// arguments.
  ///
  /// `my-program -v input-file.txt --dry-run --exit-on-failure`
  final bool allowTrailingArguments;

  const Parser({
    this.description,
    this.extendedHelp,
    this.minimumExtras,
    this.maximumExtras,
    this.exitOnFailure = true,
    this.strict = false,
    this.argumentTerminator = '--',
    this.allowTrailingArguments = true,
  });
}
