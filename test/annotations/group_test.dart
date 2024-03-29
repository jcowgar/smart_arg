import 'package:smart_arg/smart_arg.dart';
import 'package:test/test.dart';

void main() {
  group('annotations', () {
    group('group', () {
      test('constructs', () {
        final group =
            Group(name: 'Name', beforeHelp: 'before', afterHelp: 'after');
        expect(group.name, 'Name');
        expect(group.beforeHelp, 'before');
        expect(group.afterHelp, 'after');
      });
    });
  });
}
