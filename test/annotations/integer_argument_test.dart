import 'package:smart_arg/smart_arg.dart';
import 'package:test/test.dart';

void main() {
  group('IntegerArgument', () {
    group('handleValue', () {
      test('simple value', () {
        final arg = IntegerArgument();

        expect(arg.handleValue('key', '300'), 300);
      });

      group('minimum/maximum', () {
        test('in range', () {
          final arg = IntegerArgument(minimum: 100, maximum: 500);
          expect(arg.handleValue('key', '300'), 300);
        });

        test('too low', () {
          try {
            final arg = IntegerArgument(minimum: 100, maximum: 500);
            final _ = arg.handleValue('key', '95');

            fail('value lower than minimum should have thrown an exception');
          } on ArgumentError {
            expect(1, 1);
          }
        });

        test('too high', () {
          try {
            final arg = IntegerArgument(minimum: 100, maximum: 500);
            final _ = arg.handleValue('key', '505');

            fail('value higher than maximum should have thrown an exception');
          } on ArgumentError {
            expect(1, 1);
          }
        });
      });
    });
  });
}
