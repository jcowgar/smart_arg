import 'package:smart_arg/smart_arg.dart';
import 'package:test/test.dart';

void main() {
  group('ExtendedHelp', () {
    test('construction', () {
      final arg = ExtendedHelp('help text', header: 'header text');
      expect(arg.help, 'help text');
      expect(arg.header, 'header text');
    });
  });
}
