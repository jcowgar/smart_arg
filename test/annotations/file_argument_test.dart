import 'dart:io';

import 'package:smart_arg/smart_arg.dart';
import 'package:test/test.dart';

void main() {
  group('FileArgument', () {
    test('emptyList', () {
      var arg = FileArgument();
      expect(arg.emptyList is List, true);

      // Make sure we can add a Directory type directly
      arg.emptyList.add(File('hello.txt'));
    });

    group('handleValue', () {
      test('returns file', () {
        var arg = FileArgument();
        var value = arg.handleValue('file', './hello.txt');

        expect(value.path, contains('/hello.txt'));
      });

      group('must exist', () {
        test('exists', () {
          var arg = FileArgument(mustExist: true);
          var value = arg.handleValue('file', './pubspec.yaml');

          expect(value.path, contains('/pubspec.yaml'));
        });

        test('does not exists', () {
          var arg = FileArgument(mustExist: true);

          try {
            var _ = arg.handleValue('file', './does-not-exist.txt');
            fail('file does not exist, an exception should have been thrown');
          } on ArgumentError {
            expect(1, 1);
          }
        });
      });
    });
  });
}
