// A collection of string utilities

/// Split text by EOL character
List<String> splitByEOL(s) {
  return s.split(RegExp(r'\r\n|[\r\n]'));
}

/// Hard wrap given [s] to [columns]
String hardWrap(String s, [int columns = 80]) {
  final reSplitter = RegExp(r'(\r\n|[\r\n]){2,}');
  final paragraphs = s.split(reSplitter);

  List<String> result = [];

  for (var p in paragraphs) {
    p = p.trim();
    p = p.replaceAll(RegExp(r'\s{2,}'), ' ');

    final reLines = RegExp('.{1,${columns - 1}}(?:\\s+|\$)|.{${columns}}');
    final instances = reLines.allMatches(p);
    final lines = instances.map((v) => p.substring(v.start, v.end).trim());
    result.addAll(lines);
    result.add('');
  }
  return result.join('\n').trim();
}

String indent(String s, int indentBy, [String withChar = ' ']) {
  return splitByEOL(s).map((v) => (withChar * indentBy) + v).join('\n');
}

void main() {
  var s = r'''
This pattern will split paragraphs into lines no longer than 35 characters each. It is designed to break on an EOL character, on one or more spaces, or at the end of the document. It will eliminate the extra spaces, if any, at the end of        the line. If a paragraph contains a really, really, really long, spaceless line, like this:

1234567890123456789012345678901234567890123456789012345678901234567890

It will break at exactly 35 characters. Note that the only side-effect is that you will get a trailing EOL at the end of the match.

The ">" in the Replace Pattern is to demonstrate how to emulate e-mail style quoting. Remove it if you just want to wrap the lines, or replace it with "\t" or spaces if you want to indent each line.
  ''';

  var t = hardWrap(s, 40);
  t = indent(t, 20);
  print(t);
}
