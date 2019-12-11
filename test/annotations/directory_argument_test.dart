import 'dart:io';

import 'package:smart_arg/smart_arg.dart';
import 'package:test/test.dart';

void main() {
  group('DirectoryArgument', () {
    test('emptyList', () {
      var arg = DirectoryArgument();
      expect(arg.emptyList is List, true);

      // Make sure we can add a Directory type directly
      arg.emptyList.add(Directory('.'));
    });

    group('handleValue', () {
      test('returns directory', () {
        var arg = DirectoryArgument();
        var value = arg.handleValue('dir', './lib');

        expect(value.path, contains('/lib'));
      });

      group('must exist', () {
        test('exists', () {
          var arg = DirectoryArgument(mustExist: true);
          var value = arg.handleValue('dir', './lib');

          expect(value.path, contains('/lib'));
        });

        test('does not exists', () {
          var arg = DirectoryArgument(mustExist: true);

          try {
            var _ = arg.handleValue('dir', './bad-directory-name');
            fail(
                'directory does not exist, an exception should have been thrown');
          } on ArgumentError {
            expect(1, 1);
          }
        });
      });
    });
  });
}
