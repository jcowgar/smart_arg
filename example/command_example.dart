import 'package:smart_arg/smart_arg.dart';

@Parser()
class GetCommand extends SmartArgCommand {
  @BooleanArgument(help: 'Should the file be removed after downloaded?')
  bool removeAfterGet;

  @override
  void execute(SmartArg parentArguments) {
    if ((parentArguments as Args).verbose == true) {
      print('Verbose is on');
    } else {
      print('Verbose is off');
    }

    print('Getting file...');

    if (removeAfterGet == true) {
      print('Removing file on remote server (not really)');
    }
  }
}

@Parser()
class PutCommand extends SmartArgCommand {
  @BooleanArgument(help: 'Should the file be removed locally after downloaded?')
  bool removeAfterPut;

  @override
  void execute(SmartArg parentArguments) {
    if ((parentArguments as Args).verbose == true) {
      print('Verbose is on');
    } else {
      print('Verbose is off');
    }

    print('Putting file...');

    if (removeAfterPut == true) {
      print('Removing file on local disk (not really)');
    }
  }
}

@Parser(description: 'Example using commands')
class Args extends SmartArg {
  @BooleanArgument(short: 'v', help: 'Verbose mode')
  bool verbose;

  @Command(help: 'Get a file from the remote server')
  GetCommand get;

  @Command(help: 'Put a file on the remote server')
  PutCommand put;
}

void main(List<String> arguments) {
  Args()..parse(arguments);
}
