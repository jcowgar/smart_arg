import 'dart:mirrors';

import 'argument.dart';
import 'parser.dart';

// Convert `areYouAlive` to `are-you-alive`
String camelToDash(String value) {
  var r = RegExp(r'(^.|[A-Z])[^A-Z]*');
  var indexes = r.allMatches(value);
  var result = [];

  for (var index in indexes) {
    result.add(value.substring(index.start, index.end));
  }

  return result.join('-').toLowerCase();
}

class MirrorParameterPair {
  final VariableMirror mirror;
  final Argument argument;
  String displayKey;

  MirrorParameterPair(this.mirror, this.argument);

  List<String> keys(Parser parser) {
    List<String> result = [];

    String long;
    String short;

    if (argument.short != null) {
      short = argument.short;

      result.add('-$short');
    }

    if (argument.long == null && parser.strict != true) {
      long = camelToDash(MirrorSystem.getName(mirror.simpleName));

      result.add(long);
    } else if (argument.long is String) {
      long = argument.long;

      result.add(long);
    }

    result.addAll(argument.specialKeys(short, long));

    displayKey = long is String ? long : short;

    if (displayKey == null) {
      throw StateError(
          'No key could be found for ${MirrorSystem.getName(mirror.simpleName)}');
    } else if (short?.startsWith('-') ?? false) {
      throw StateError(
          'Short key ($short) defined by short: should not include a leading -');
    } else if (long?.startsWith('-') ?? false) {
      throw StateError(
          'Long key ($short) defined by long: should not include a leading -');
    }

    return result;
  }
}
