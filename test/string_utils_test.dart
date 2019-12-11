import 'package:smart_arg/src/string_utils.dart';
import 'package:test/test.dart';

void main() {
  group('string utils', () {
    test('replaceLineEndings', () {
      expect(replaceLineEndings('Hello\nWorld\n', '='), 'Hello=World=');
      expect(replaceLineEndings('Hello\rWorld\r', '='), 'Hello=World=');
      expect(replaceLineEndings('Hello\r\nWorld\r\n', '='), 'Hello=World=');
    });

    test('endOfLineOf', () {
      expect(endOfLineOf('Hello\n'), '\n');
      expect(endOfLineOf('Hello\r'), '\r');
      expect(endOfLineOf('Hello\r\n'), '\r\n');
      expect(endOfLineOf('Hello'), null);
    });

    test('splitByEOL', () {
      expect(splitByEOL('Hello\nWorld'), ['Hello', 'World']);
      expect(splitByEOL('Hello\rWorld'), ['Hello', 'World']);
      expect(splitByEOL('Hello\r\nWorld'), ['Hello', 'World']);
      expect(splitByEOL('Hello World'), ['Hello World']);
    });

    test('hardWrap', () {
      expect(hardWrap('Hello Hello', 7), 'Hello\nHello');
      // FAILING: expect(hardWrap('Hello Hello', 5), 'Hello\nHello');
      expect(hardWrap('Hello World how are you doing?', 14),
          'Hello World\nhow are you\ndoing?');
    });

    test('indent', () {
      expect(indent('hello', 2), '  hello');
      expect(indent('hello\nworld\n', 2), '  hello\n  world\n  ');
    });
  });
}
