import 'dart:io';

import 'package:smart_arg/smart_arg.dart';

import 'advanced_command_example.reflectable.dart';

/// A basic mixin for adding a the help argument to each [SmartArg] extension
@SmartArg.reflectable
mixin HelpArg {
  @HelpArgument()
  bool? help;

  void printUsageAndExitIfHelpRequested() {
    if (help == true) {
      final SmartArg arg = this as SmartArg;
      print(arg.usage());
      exit(0);
    }
  }
}

/// A basic mixin for adding a Docker Image argument to each [SmartArg] extension
@SmartArg.reflectable
mixin DockerImageArg {
  @StringArgument(help: 'Docker Image')
  String? image = 'dart:stable';
}

@SmartArg.reflectable
@Parser(description: 'Pulls a Docker Image')
class DockerPullCommand extends SmartArgCommand with HelpArg, DockerImageArg {
  @override
  void execute(SmartArg parentArguments) {
    printUsageAndExitIfHelpRequested();
    print('\$ docker pull $image');
  }
}

@SmartArg.reflectable
@Parser(description: 'Runs a Docker Image')
class DockerRunCommand extends SmartArgCommand with HelpArg, DockerImageArg {
  @BooleanArgument(help: 'Pull image before running')
  bool pull = false;

  @override
  void execute(SmartArg parentArguments) {
    printUsageAndExitIfHelpRequested();
    print('\$ docker run${pull ? ' --pull' : ''} $image');
  }
}

@SmartArg.reflectable
@Parser(
  description: 'Example of using mixins to reduce argument declarations',
)
class Args extends SmartArg with HelpArg {
  @BooleanArgument(short: 'v', help: 'Verbose mode')
  bool? verbose;

  @Command(help: 'Pulls a Docker Image')
  DockerPullCommand? pull;

  @Command(help: 'Runs a Docker Image')
  DockerRunCommand? run;
}

void main(List<String> arguments) {
  initializeReflectable();
  var args = Args()..parse(arguments);
  args.printUsageAndExitIfHelpRequested();
}
