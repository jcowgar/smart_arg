import 'dart:io';

import 'package:smart_arg/smart_arg.dart';

import 'readme_example.reflectable.dart';

@SmartArg.parser
@Parser(description: 'Hello World application')
class Args extends SmartArg {
  @StringArgument(help: 'Name of person to say hello to')
  String name = 'World'; // Default to World

  @StringArgument(
    help: 'Message to say to person',
    mustBeOneOf: ['Hello', 'Goodbye'],
  )
  String greeting = 'Hello'; // Default to Hello

  @IntegerArgument(
    help: 'Number of times to greet the person',
    isRequired: true,
    minimum: 1,
    maximum: 100,
  )
  int count;

  @HelpArgument()
  bool help = false;
}

void main(List<String> arguments) {
  initializeReflectable();

  var args = Args()..parse(arguments);
  if (args.help) {
    print(args.usage());
    exit(0);
  }

  for (int i = 0; i < args.count; i++) {
    print('${args.greeting}, ${args.name}!');
  }
}
