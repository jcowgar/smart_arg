Smart Arg
=========

[![Build Status](https://travis-ci.org/jcowgar/smart_arg.svg?branch=master)](https://travis-ci.org/jcowgar/smart_arg)
[![codecov](https://codecov.io/gh/jcowgar/smart_arg/branch/master/graph/badge.svg)](https://codecov.io/gh/jcowgar/smart_arg)

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

## Simple Example

```dart
import 'dart:io';

import 'package:smart_arg/smart_arg.dart';

@Parser(description: 'Hello World application')
class Args extends SmartArg {
  @StringArgument(help: 'Name of person to say hello to')
  String name = 'World';    // Default to World

  @StringArgument(
    help: 'Greeting text to use',
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
  var args = Args()..parse(arguments);
  if (args.help) {
    print(args.usage());
    exit(0);
  }

  for (int i = 0; i < args.count; i++) {
    print('${args.greeting}, ${args.name}!');
  }
}
```

Please see the API documentation for a better understanding of what `Argument` types exist as well as their individual options.

## Help Output

The help output of the above example is:

```
Hello World application

  --name         Name of person to say hello to
  --greeting     Greeting text to use
                 must be one of Hello, Goodbye
  --count        Number of times to greet the person
                 [REQUIRED]
  -h, --help, -? Show help
```

A more complex example [smart_arg_example.dart][smart_arg_example.dart]
produces the following output:

```
Example smart arg application

Group 1
  This is some long text that explains this section in detail. Blah blah blah
  blah blah blah blah blah. This will be wrapped as needed. Thus, it will
  display beautifully in the console.

  --names        no help available
  -r, --header   Report header text
  --filename     Filename to report stats on

  This is just a single sentence but even it will be wrapped if necessary

Group 2 -- OTHER
  Help before

  --count        Count of times to say hello
  --silly        Some other silly parameter to show double parsing. This also
                 has a very long description that should word wrap in the
                 output and produce beautiful display.
  -v, --verbose, --no-verbose
                 Turn verbose mode on.

                 This is an example also of using multi-line help text that
                 is formatted inside of the editor. This should be one
                 paragraph. I'll add some more content here. This will be the
                 last sentence of the first paragraph.

                 This is another paragraph formatted very narrowly in the
                 code editor. Does it look the same as the one above? I sure
                 hope that it does. It would make help display very easy to
                 implement.
  -h, --help, -? Show help

  Help after

This is a simple application that does nothing and contains silly arguments.
It simply shows how the smart_arg library can be used.

No one should really try to use this program outside of those interested in
using smart_arg in their own applications.

SECTION 2
  This is more extended text that can be put into its own section.
```

## Command Execution

More complex command line applications often times have commands. These commands
then also have options of their own. `SmartArg` accomplishes this very easily:

```dart
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
```

## Features and bugs

Please send pull requests, feature requests and bug reports to the
[issue tracker][tracker].

[tracker]: https://github.com/jcowgar/smart_arg
[smart_arg_example.dart]: https://github.com/jcowgar/smart_arg/blob/master/example/smart_arg_example.dart