import 'dart:io';

import 'package:smart_arg/smart_arg.dart';

@Parser(
  description: 'Example smart arg application',
  minimumExtras: 1,
  maximumExtras: 1,
  exitOnFailure: true,
  extendedHelp: '''
      This is a simple application that does nothing and contains silly
      arguments. It simply shows how the smart_arg library can be used.

      No one should really try to use this program outside of those interested
      in using smart_arg in their own applications.''',
)
class Args extends SmartArg {
  @StringArgument()
  List<String> names;

  @StringArgument(
    short: 'r',
    help: 'Report header text',
  )
  String header;

  @FileArgument(
    help: 'Filename to report stats on',
    mustExist: true,
  )
  File filename;

  @IntegerArgument(
    help: 'Count of times to say hello',
  )
  int count;

  @DoubleArgument(
    help: 'Some other silly parameter to show double parsing',
  )
  double silly;

  @BooleanArgument(
    short: 'v',
    help: 'Turn verbose mode on',
    isNegateable: true,
  )
  bool verbose = false;

  @HelpArgument()
  bool help = false;
}

void main(List<String> arguments) {
  var args = Args()..parse(arguments);

  if (args.help) {
    print(args.usage());
    exit(0);
  }

  print('header  : ${args.header}');
  print('filename: ${args.filename}');
  print('verbose : ${args.verbose}');
  print('count   : ${args.count}');
  print('silly   : ${args.silly}');
  print('names   : ${args.names?.join(', ')}');
  print('extras  : ${args.extras.join(' ')}');
}
