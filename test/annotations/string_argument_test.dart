import 'package:smart_arg/smart_arg.dart';
import 'package:test/test.dart';

void main() {
  group('StringArgument', () {
    group('handleValue', () {
      test('simple value', () {
        final arg = StringArgument();

        expect(arg.handleValue('key', 'hello'), 'hello');
      });

      test('must be one of (valid)', () {
        final arg = StringArgument(mustBeOneOf: ['hello', 'howdy']);
        expect(arg.handleValue('key', 'hello'), 'hello');
      });

      test('must be one of (invalid)', () {
        try {
          final arg = StringArgument(mustBeOneOf: ['hello', 'howdy']);
          arg.handleValue('key', 'cya');
          fail('invalid must of should have thrown an error');
        } on ArgumentError {
          expect(1, 1);
        }
      });
    });
  });
}
