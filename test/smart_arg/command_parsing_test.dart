import 'package:test/test.dart';

import 'package:smart_arg/smart_arg.dart';

import 'command_parsing_test.reflectable.dart';

String whatExecuted;

@SmartArg.parser
@Parser(exitOnFailure: false, description: 'put command')
class PutCommand extends SmartArgCommand {
  @StringArgument()
  String filename;

  @override
  void execute(SmartArg parentArguments) {
    whatExecuted = 'put-command: $filename';
  }
}

@SmartArg.parser
@Parser(exitOnFailure: false, description: 'get command')
class GetCommand extends SmartArgCommand {
  @StringArgument()
  String filename;

  @override
  void execute(SmartArg parentArguments) {
    whatExecuted = 'get-command: $filename';
  }
}

@SmartArg.parser
@Parser(exitOnFailure: false)
class TestSimpleCommand extends SmartArg {
  @BooleanArgument(short: 'v')
  bool verbose;

  @Command(help: 'Put a file on a remote host')
  PutCommand put;

  @Command(help: 'Get a file from a remote host')
  GetCommand get;
}

void main() {
  initializeReflectable();

  group('parsing', () {
    group('commands', () {
      setUp(() {
        whatExecuted = null;
      });

      test('executes with no arguments', () {
        final args = TestSimpleCommand()..parse([]);
        expect(args.verbose, null);
      });

      test('executes with a command', () {
        final args = TestSimpleCommand()
          ..parse(['-v', 'put', '--filename=upload.txt']);
        expect(args.verbose, true);
        expect(whatExecuted, 'put-command: upload.txt');
      });

      test('executes with another command', () {
        final args = TestSimpleCommand()
          ..parse(['-v', 'get', '--filename=download.txt']);
        expect(args.verbose, true);
        expect(whatExecuted, 'get-command: download.txt');
      });

      test('help appears', () {
        final args = TestSimpleCommand();
        final help = args.usage();

        expect(help.contains('COMMANDS'), true);
        expect(help.contains('  get'), true);
        expect(help.contains('  put'), true);
        expect(help.contains('Get a file'), true);
        expect(help.contains('Put a file'), true);
      });
    });
  });
}
