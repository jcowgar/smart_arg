import 'package:smart_arg/smart_arg.dart';
import 'package:test/test.dart';

void main() {
  group('Parser', () {
    test('Parser', () {
      var app = Parser();
      expect(app, isNotNull);
    });
  });
}
