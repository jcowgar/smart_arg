import 'package:smart_arg/smart_arg.dart';
import 'package:test/test.dart';

void main() {
  group('HelpArgument', () {
    test('specialKeys', () {
      var arg = HelpArgument();
      expect(arg.specialKeys('h', 'help'), ['-?']);
    });
  });
}
