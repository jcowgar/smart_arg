import 'package:test/test.dart';

import 'package:smart_arg/smart_arg.dart';

void main() {
  group('argument', () {
    group('command', () {
      test('handleValue', () {
        final c = Command(help: 'Blah Command');

        // Make sure no exceptions
        c.handleValue('key', null);

        expect(1, 1);
      });
    });
  });
}
