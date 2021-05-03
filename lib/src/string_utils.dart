// A collection of string utilities

/// Replace all EOL in [s] with [replaceWith]
String replaceLineEndings(String s, String replaceWith) {
  return s.replaceAll(RegExp(r'\r\n|[\r\n]'), replaceWith);
}

/// Gets the EOL character of [s]
String endOfLineOf(String s) {
  final match = RegExp(r'\r\n|[\r\n]').firstMatch(s);
  if (match == null) {
    return null;
  } else {
    return s.substring(match.start, match.end);
  }
}

/// Split text by EOL character
List<String> splitByEOL(s) {
  return s.split(RegExp(r'\r\n|[\r\n]'));
}

/// Hard wrap given [s] to [columns]
String hardWrap(String s, [int columns = 80]) {
  final eol = endOfLineOf(s) ?? '\n';

  final reSplitter = RegExp(r'(\r\n|[\r\n]){2,}');
  final paragraphs = s.split(reSplitter);

  // Local type is needed, otherwise result winds up being a
  // List<dynamic> which is incompatible with the return type.
  // Therefore, ignore the suggestion from dartanalyzer
  //
  // ignore: omit_local_variable_types
  List<String> result = [];

  for (var p in paragraphs) {
    p = p.trim();
    p = p.replaceAll(RegExp(r'\s{2,}'), ' ');

    final reLines = RegExp('.{1,${columns - 1}}(?:\\s+|\$)|.{1,$columns}');
    final instances = reLines.allMatches(p);
    final lines = instances.map((v) => p.substring(v.start, v.end).trim());
    result.addAll(lines);
    result.add('');
  }
  return result.join(eol).trim();
}

/// Indent [s] by [indentCount] columns using [withChar]
String indent(String s, int indentCount, [String withChar = ' ']) {
  final eol = endOfLineOf(s) ?? '\n';
  return splitByEOL(s).map((v) => (withChar * indentCount) + v).join(eol);
}
