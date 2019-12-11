import 'dart:io';

import 'package:test/test.dart';

import 'package:smart_arg/smart_arg.dart';

@Parser(
    exitOnFailure: false,
    description: 'app-description',
    extendedHelp: 'extended-help')
class TestSimple extends SmartArg {
  @BooleanArgument(isNegateable: true, help: 'bvalue-help')
  bool bvalue;

  @IntegerArgument(short: 'i')
  int ivalue;

  @DoubleArgument(isRequired: true)
  double dvalue;

  @StringArgument()
  String svalue;

  @FileArgument()
  File fvalue;

  @DirectoryArgument()
  Directory dirvalue;

  @StringArgument()
  String checkingCamelToDash;
}

@Parser(exitOnFailure: false)
class TestMultipleShortArgsSameKey extends SmartArg {
  @IntegerArgument(short: 'a')
  int abc;

  @IntegerArgument(short: 'a')
  int xyz;
}

@Parser(exitOnFailure: false)
class TestMultipleLongArgsSameKey extends SmartArg {
  @IntegerArgument(long: 'abc')
  int abc;

  @IntegerArgument(long: 'abc')
  int xyz;
}

@Parser(exitOnFailure: false, minimumExtras: 1, maximumExtras: 3)
class TestMinimumMaximumExtras extends SmartArg {
  @IntegerArgument()
  int a;
}

@Parser(exitOnFailure: false)
class TestFileDirectoryMustExist extends SmartArg {
  @FileArgument(mustExist: true)
  File file;

  @DirectoryArgument(mustExist: true)
  Directory directory;
}

@Parser(exitOnFailure: false)
class TestShortAndLongSameKey extends SmartArg {
  @IntegerArgument(short: 'a')
  int abc;

  @IntegerArgument()
  int a; // This is the same as the short for 'abc'
}

@Parser(exitOnFailure: false)
class TestMultipleLineArgumentHelp extends SmartArg {
  @BooleanArgument(short: 'a', help: 'Silly help message', isRequired: true)
  bool thisIsAReallyLongParameterNameThatWillCauseWordWrapping;

  @BooleanArgument(short: 'b', help: 'Another help message here')
  bool moreReasonableName;
}

@Parser(exitOnFailure: false)
class TestLongKeyHandling extends SmartArg {
  @StringArgument(long: 'over-ride-long-item-name')
  String longItem;

  @StringArgument(long: false, short: 'n')
  String itemWithNoLong;
}

@Parser(exitOnFailure: false)
class TestMustBeOneOf extends SmartArg {
  @StringArgument(mustBeOneOf: ['hello', 'howdy', 'goodbye', 'cya'])
  String greeting;
}

@Parser(exitOnFailure: false, strict: true)
class TestParserStrict extends SmartArg {
  @IntegerArgument(short: 'n')
  int nono;

  @BooleanArgument(long: 'say-hello')
  bool shouldSayHello;
}

@Parser(exitOnFailure: false)
class TestIntegerDoubleMinMax extends SmartArg {
  @IntegerArgument(minimum: 1, maximum: 5)
  int intValue;

  @DoubleArgument(minimum: 1.5, maximum: 4.5)
  double doubleValue;
}

@Parser(exitOnFailure: false)
class TestMultiple extends SmartArg {
  @StringArgument()
  List<String> names;

  @StringArgument()
  String name;
}

@Parser(exitOnFailure: false)
class TestHelpArgument extends SmartArg {
  @HelpArgument()
  bool help;
}

@Parser(exitOnFailure: false)
class TestInvalidShortKeyName extends SmartArg {
  @StringArgument(short: '-n')
  String name;
}

@Parser(exitOnFailure: false)
class TestInvalidLongKeyName extends SmartArg {
  @StringArgument(long: '-n')
  String name;
}

@Parser(exitOnFailure: false)
class TestArgumentTerminatorDefault extends SmartArg {
  @StringArgument()
  String name;

  @StringArgument()
  String other;
}

@Parser(exitOnFailure: false, argumentTerminator: null)
class TestArgumentTerminatorNull extends SmartArg {
  @StringArgument()
  String name;

  @StringArgument()
  String other;
}

@Parser(exitOnFailure: false, argumentTerminator: '--args')
class TestArgumentTerminatorSet extends SmartArg {
  @StringArgument()
  String name;

  @StringArgument()
  String other;
}

@Parser(exitOnFailure: false, allowTrailingArguments: false)
class TestDisallowTrailingArguments extends SmartArg {
  @StringArgument()
  String name;

  @StringArgument()
  String other;
}

@Parser(exitOnFailure: false)
class TestAllowTrailingArguments extends SmartArg {
  @StringArgument()
  String name;

  @StringArgument()
  String other;
}

@Parser(exitOnFailure: false)
class TestStackedBooleanArguments extends SmartArg {
  @BooleanArgument(short: 'a')
  bool avalue;

  @BooleanArgument(short: 'b')
  bool bvalue;

  @BooleanArgument(short: 'c')
  bool cvalue;

  @BooleanArgument(short: 'd')
  bool dvalue;
}

@Parser(exitOnFailure: false)
class TestNoKey extends SmartArg {
  @StringArgument(long: false)
  String long;
}

@Parser(exitOnFailure: false)
class TestWithDefaultValue extends SmartArg {
  @StringArgument()
  String long = 'hello';
}

void main() {
  group('argument parsing/assignment', () {
    test('basic arguments', () {
      var args = TestSimple()
        ..parse([
          '--bvalue',
          '--ivalue',
          '500',
          '--dvalue',
          '12.625',
          '--svalue',
          'hello',
          '--fvalue',
          'hello.txt',
          '--dirvalue',
          '.',
          '--checking-camel-to-dash',
          'yes-it-works',
          'extra1',
          'extra2',
        ]);

      expect(args.bvalue, true);
      expect(args.ivalue, 500);
      expect(args.dvalue, 12.625);
      expect(args.svalue, 'hello');
      expect(args.fvalue is File, true);
      expect(args.dirvalue is Directory, true);
      expect(args.checkingCamelToDash, 'yes-it-works');
      expect(args.extras.length, 2);
    });

    test('--no-bvalue', () {
      var args = TestSimple()..parse(['--no-bvalue', '--dvalue=10.0']);

      expect(args.bvalue, false);
    });

    test('short key', () {
      var args = TestSimple()..parse(['-i', '300', '--dvalue=10.0']);

      expect(args.ivalue, 300);
    });

    test('stacked boolean flags', () {
      var args = TestStackedBooleanArguments()..parse(['-ab', '-c']);
      expect(args.avalue, true);
      expect(args.bvalue, true);
      expect(args.cvalue, true);
      expect(args.dvalue, null);
    });

    test('long key with equal', () {
      var args = TestSimple()
        ..parse(['--ivalue=450', '--dvalue=55.5', '--svalue=John']);

      expect(args.ivalue, 450);
      expect(args.dvalue, 55.5);
      expect(args.svalue, 'John');
    });

    group('default value', () {
      test('default value exists if no argument given', () {
        var args = TestWithDefaultValue()..parse([]);
        expect(args.long, 'hello');
      });

      test('value supplied overrides default value', () {
        var args = TestWithDefaultValue()..parse(['--long', 'goodbye']);
        expect(args.long, 'goodbye');
      });
    });

    group('list handling', () {
      test('allow', () {
        var args = TestMultiple()..parse(['--names=John', '--names', 'Jack']);
        expect(args.names[0], 'John');
        expect(args.names[1], 'Jack');
      });

      test('disallow but supply multiple', () {
        try {
          var _ = TestMultiple()..parse(['--name=John', '--name=Jack']);
          fail(
              'supplying multiple parameters when allowMultiple = null should have thrown an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });
    });

    test('invalid argument is caught', () {
      try {
        var _ = TestSimple()..parse(['--dvalue=55.5', '--invalid']);
        fail('invalid argument did not throw an exception');
      } on ArgumentError {
        expect(1, 1);
      }
    });

    test('not supplying argument', () {
      try {
        var _ = TestSimple()..parse(['--dvalue']);
        fail('no value did not throw an exception');
      } on ArgumentError {
        expect(1, 1);
      }
    });

    test('missing a required argument throws an error', () {
      try {
        var _ = TestSimple()..parse([]);
        fail('missing required argument did not throw an exception');
      } on ArgumentError {
        expect(1, 1);
      }
    });

    test('same argument being supplied multiple times', () {
      try {
        var _ = TestSimple().parse(['--dvalue=5.5', '--dvalue=5.5']);
        fail(
            'same argument supplied multiple times did not thrown an exception');
      } on ArgumentError catch (e) {
        expect(e.toString(), contains('more than once'));
      }
    });

    group('must be one of', () {
      test('works', () {
        var args = TestMustBeOneOf()..parse(['--greeting=hello']);
        expect(args.greeting, 'hello');
      });

      test('catches invalid value', () {
        try {
          var _ = TestMustBeOneOf()..parse(['--greeting=later']);
          fail('not one of must be one of did not thrown an exception');
        } on ArgumentError catch (e) {
          expect(e.toString(), contains('must be one of'));
        }
      });
    });

    group('integer parameter', () {
      test('works', () {
        var _ = TestIntegerDoubleMinMax()..parse(['--int-value=2']);
      });

      test('throws an error when below the range', () {
        try {
          var _ = TestIntegerDoubleMinMax()..parse(['--int-value=0']);
          fail('an integer below the minimum did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('throws an error when above the range', () {
        try {
          var _ = TestIntegerDoubleMinMax()..parse(['--int-value=100']);
          fail('an integer below the maximum did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });
    });

    group('double parameter', () {
      test('works', () {
        var _ = TestIntegerDoubleMinMax()..parse(['--double-value=2.5']);
      });

      test('throws an error when below the range', () {
        try {
          var _ = TestIntegerDoubleMinMax()..parse(['--double-value=1.1']);
          fail('a double below the minimum did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('throws an error when above the range', () {
        try {
          var _ = TestIntegerDoubleMinMax()..parse(['--double-value=4.6']);
          fail('a double below the maximum did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });
    });

    test('not enough extras', () {
      try {
        var _ = TestMinimumMaximumExtras()..parse([]);
        fail('not enough extras did not throw an exception');
      } on ArgumentError {
        expect(1, 1);
      }
    });

    test('enough extras', () {
      var args = TestMinimumMaximumExtras()..parse(['extra1']);
      expect(args.extras.length, 1);
    });

    test('too many extras', () {
      try {
        var _ = TestMinimumMaximumExtras()
          ..parse(['extra1', 'extra2', 'extra3', 'extra4']);
        fail('too many extras did not throw an exception');
      } on ArgumentError {
        expect(1, 1);
      }
    });

    group('trailing arguments', () {
      test('by default allows', () {
        var args = TestAllowTrailingArguments()
          ..parse(['--name=John', 'hello.txt', '--other=Jack']);
        expect(args.name, 'John');
        expect(args.other, 'Jack');
        expect(args.extras.length, 1);
        expect(args.extras.contains('hello.txt'), true);
      });

      test('when turned off trailing arguments become extras', () {
        var args = TestDisallowTrailingArguments()
          ..parse(['--name=John', 'hello.txt', '--other=Jack']);
        expect(args.name, 'John');
        expect(args.other, null);
        expect(args.extras.length, 2);
        expect(args.extras.contains('hello.txt'), true);
        expect(args.extras.contains('--other=Jack'), true);
      });
    });

    group('file must exist', () {
      test('file that does not exist', () {
        try {
          var _ = TestFileDirectoryMustExist()
            ..parse(['--file=./file-that-does-not-exist.txt']);
          fail('file that does not exist did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('file that exists', () {
        var args = TestFileDirectoryMustExist()
          ..parse(['--file=./pubspec.yaml']);
        expect(args.file.path, contains('pubspec.yaml'));
      });
    });

    group('argumentTerminator', () {
      test('default', () {
        var args = TestArgumentTerminatorDefault()
          ..parse(['--name=John', '--', '--other=Jack', 'Doe']);
        expect(args.name, 'John');
        expect(args.other, null);
        expect(args.extras.length, 2);
        expect(args.extras.contains('--other=Jack'), true);
        expect(args.extras.contains('Doe'), true);
      });

      test('set to null but try to use', () {
        try {
          var _ = TestArgumentTerminatorNull()
            ..parse(['--name=John', '--', '--other=Jack', 'Doe']);
          fail(
              'null argument terminator and -- should have thrown an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('null terminator without use', () {
        var args = TestArgumentTerminatorDefault()
          ..parse(['--name=John', '--other=Jack', 'Doe']);
        expect(args.name, 'John');
        expect(args.other, 'Jack');
        expect(args.extras.length, 1);
        expect(args.extras.contains('Doe'), true);
      });

      test('set to --args', () {
        var args = TestArgumentTerminatorSet()
          ..parse(['--name=John', '--args', '--other=Jack', 'Doe']);
        expect(args.name, 'John');
        expect(args.other, null);
        expect(args.extras.length, 2);
        expect(args.extras.contains('--other=Jack'), true);
        expect(args.extras.contains('Doe'), true);
      });

      test('set to --args but using mixed case for argument terminator', () {
        var args = TestArgumentTerminatorSet()
          ..parse(['--name=John', '--ArGS', '--other=Jack', 'Doe']);
        expect(args.name, 'John');
        expect(args.other, null);
        expect(args.extras.length, 2);
        expect(args.extras.contains('--other=Jack'), true);
        expect(args.extras.contains('Doe'), true);
      });

      test('set to --args but not used', () {
        var args = TestArgumentTerminatorSet()
          ..parse(['--name=John', '--other=Jack', 'Doe']);
        expect(args.name, 'John');
        expect(args.other, 'Jack');
        expect(args.extras.length, 1);
        expect(args.extras.contains('Doe'), true);
      });
    });

    test('invalid short name parameter', () {
      try {
        var _ = TestInvalidShortKeyName()..parse([]);
        fail('invalid short name did not throw an exception');
      } on StateError {
        expect(1, 1);
      }
    });

    test('invalid long name parameter', () {
      try {
        var _ = TestInvalidLongKeyName()..parse([]);
        fail('invalid long name did not throw an exception');
      } on StateError {
        expect(1, 1);
      }
    });

    test('short and long parameters with the same name', () {
      var args = TestShortAndLongSameKey()..parse(['-a=5', '--a=10']);
      expect(args.abc, 5);
      expect(args.a, 10);
    });

    group('strict setting on', () {
      test('has no long option when one was not specified', () {
        try {
          var _ = TestParserStrict()..parse(['--nono=12']);
          fail('specifying the parameter name should have thrown an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('short option for non-long option works', () {
        var args = TestParserStrict()..parse(['-n=12']);
        expect(args.nono, 12);
      });

      test('long option added works', () {
        var args = TestParserStrict()..parse(['--say-hello']);
        expect(args.shouldSayHello, true);
      });
    });

    group('long argument override', () {
      test('long item can be overridden', () {
        var args = TestLongKeyHandling()..parse([]);
        expect(args.usage().contains('over-ride-long-item-name'), true);
        expect(args.usage().contains('longItem'), false);
      });

      test('long item does not display', () {
        var args = TestLongKeyHandling()..parse([]);
        expect(args.usage().contains('-n'), true);
        expect(args.usage().contains('itemWithNoLong'), false);
        expect(args.usage().contains('item-with-no-long'), false);
      });

      test('some argument must exist', () {
        try {
          var _ = TestNoKey()..parse([]);
          fail('no key at all should have thrown an exception');
        } on StateError {
          expect(1, 1);
        }
      });
    });

    group('directory must exist', () {
      test('directory that does not exist', () {
        try {
          var _ = TestFileDirectoryMustExist()
            ..parse(['--directory=./directory-that-does-not-exist']);
          fail('directory that does not exist did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('directory that exists', () {
        var args = TestFileDirectoryMustExist()..parse(['--directory=./lib']);
        expect(args.directory.path, contains('lib'));
      });
    });
  });

  group('bad configuration', () {
    test('same short argument multiple times', () {
      try {
        var _ = TestMultipleShortArgsSameKey()..parse([]);
        fail('same short arg multiple times did not throw an exception');
      } on StateError {
        expect(1, 1);
      }
    });

    test('same long argument multiple times', () {
      try {
        var _ = TestMultipleLongArgsSameKey()..parse([]);
        fail('same long arg multiple times did not throw an exception');
      } on StateError {
        expect(1, 1);
      }
    });
  });

  group('help generation', () {
    test('help contains app description', () {
      var args = TestSimple()..parse(['--dvalue=10.0']);
      expect(args.usage(), contains('app-description'));
    });

    test('help contains extended help', () {
      var args = TestSimple()..parse(['--dvalue=10.0']);
      expect(args.usage(), contains('extended-help'));
    });

    test('help contains short key for ivalue', () {
      var args = TestSimple()..parse(['--dvalue=10.0']);
      expect(args.usage(), contains('-i,'));
    });

    test('help contains long key for ivalue', () {
      var args = TestSimple()..parse(['--dvalue=10.0']);
      expect(args.usage(), contains('--ivalue'));
    });

    test('help contains [REQUIRED] for --dvalue', () {
      var args = TestSimple()..parse(['--dvalue=10.0']);
      expect(args.usage(), contains('[REQUIRED]'));
    });

    test('help contains must be one of', () {
      var args = TestMustBeOneOf();
      expect(args.usage(), contains('must be one of'));
    });

    test('help contains dashed long key for checkingCamelToDash', () {
      var args = TestSimple()..parse(['--dvalue=10.0']);
      expect(args.usage(), contains('--checking-camel-to-dash'));
    });

    test('parameter wrapping', () {
      var args = TestMultipleLineArgumentHelp()..parse(['-a=1']);
      expect(args.usage(), matches(RegExp(r'.*\n\s+Silly help message')));
      expect(args.usage(), matches(RegExp(r'.*\n\s+\[REQUIRED\]')));
    });

    test('help works with -?', () {
      var args = TestHelpArgument()..parse(['-?']);
      expect(args.help, true);
    });

    test('help works with -h', () {
      var args = TestHelpArgument()..parse(['-h']);
      expect(args.help, true);
    });

    test('help works with --help', () {
      var args = TestHelpArgument()..parse(['--help']);
      expect(args.help, true);
    });

    test('help ignores parameters after help flag', () {
      var args = TestHelpArgument()
        ..parse(['-?', '--bad-argument1', '-b', 'hello']);
      expect(args.help, true);
      expect(args.extras.contains('--bad-argument1'), true);
      expect(args.extras.contains('-b'), true);
      expect(args.extras.contains('hello'), true);
    });
  });
}
