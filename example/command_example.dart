import 'dart:io';

import 'package:smart_arg/smart_arg.dart';

@Parser(description: 'get file from remote server')
class GetCommand extends SmartArgCommand {
  @BooleanArgument(help: 'Should the file be removed after downloaded?')
  bool removeAfterGet;

  @HelpArgument()
  bool help;

  @override
  void execute(SmartArg parentArguments) {
    if (help == true) {
      print(usage());
      exit(0);
    }

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

@Parser(description: 'put file onto remote server')
class PutCommand extends SmartArgCommand {
  @BooleanArgument(help: 'Should the file be removed locally after downloaded?')
  bool removeAfterPut;

  @HelpArgument()
  bool help;

  @override
  void execute(SmartArg parentArguments) {
    if (help == true) {
      print(usage());
      exit(0);
    }

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

@Parser(
  description: 'Example using commands',
  extendedHelp: [
    ExtendedHelp('This is some text below the command listing',
        header: 'EXTENDED HELP')
  ],
)
class Args extends SmartArg {
  @BooleanArgument(short: 'v', help: 'Verbose mode')
  bool verbose;

  @Command(help: 'Get a file from the remote server')
  GetCommand get;

  @Command(help: 'Put a file on the remote server')
  PutCommand put;

  @HelpArgument()
  bool help;
}

void main(List<String> arguments) {
  var args = Args()..parse(arguments);

  if (args.help == true) {
    print(args.usage());
    exit(0);
  }
}
