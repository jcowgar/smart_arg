Smart Arg
=========

A simple to use command line argument parser. The main rationale behind this
argument parser is the use of a class to store the argument values. Therefore,
you gain static type checking and code completion.

Types currently supported are: `bool`, `int`, `double`, `String`, `File`,
and `Directory`. Defaults can be supplied as any other Dart class and one
can determine if a parameter was set based on it's value being null or not.
Types can also be defined as a `List<T>` to support multiple arguments of the
same name to be specified on the command line. Anything passed on the command
line that is not an option will be considered an extra, of which you can
demand a minimum and/or maximum requirement.

Through the use of annotations, each parameter (and main class) can have
various attributes set such as help text, if the parameter is required, if
the file must exist on disk, can the parameter be negated, a short alias,
and more.

Beautiful help is of course generated automatically when the user gives an
incorrect parameter or misses a required parameter or extra.

## Usage

A simple example:

```dart
import 'package:smart_arg/smart_arg.dart';

@Parser(description: 'Hello World application')
class Args extends SmartArg {
  @StringParameter(help: 'Name of person to say hello to')
  String name = 'World';

  @StringParameter(help: 'Greeting text to use')
  String greeting = 'Hello';

  @IntegerParameter(
    help: 'Number of times to greet the person',
    isRequired: true,
    minimum: 1,
    maximum: 100,
  )
  int count;
}

main(List<String> arguments) {
  var args = Args()..parse(arguments);

  for (int i = 0; i < args.count; i++) {
    print('${args.greeting}, ${args.name}!');
  }
}
```

## Features and bugs

Please send pull requests, feature requests and bug reports to the
[issue tracker][tracker].

## What is yet to come?

1. The library is in its infancy and the structure/naming may change.
2. Commands, or sub applications with their own arguments and automatic
   dispatching.
3. Better adherance to standard option parsing practices, such as short
   flag parameters being able to be stacked (`-vgc`).

[tracker]: https://github.com/jcowgar/smart_arg
