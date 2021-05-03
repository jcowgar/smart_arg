import 'dart:io';

import 'package:path/path.dart' as path;

import 'argument.dart';

class FileArgument extends Argument {
  /// If supplied, must this `File` property actually exist on disk?
  ///
  /// If the value is `true` and the file does *not* exist, then the user will
  /// be told there is an error, will be shown the help screen and if
  /// [SmartArgApp.exitOnFailure] is set to `true`, the application will exit
  /// with the error code 1.
  final bool mustExist;

  const FileArgument({
    String short,
    dynamic long,
    String help,
    bool isRequired,
    this.mustExist = false,
  }) : super(
          short: short,
          long: long,
          help: help,
          isRequired: isRequired,
        );

  @override
  File handleValue(String key, dynamic value) {
    var result;

    var normalizedAbsolutePath = path.normalize(path.absolute(value));
    result = File(normalizedAbsolutePath);

    if (mustExist) {
      if (result.existsSync() == false) {
        throw ArgumentError('$result for parameter $key does not exist');
      }
    }

    return result;
  }

  List<File> get emptyList => [];
}
