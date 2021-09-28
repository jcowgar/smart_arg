import 'dart:io';
import 'package:smart_arg/smart_arg.dart';
import 'smart_arg_example.reflectable.dart';

@SmartArg.reflectable
@Parser(
  description: 'Example smart arg application',
  minimumExtras: 1,
  maximumExtras: 1,
  exitOnFailure: true,
  extendedHelp: [
    ExtendedHelp('''
      This is a simple application that does nothing and contains silly arguments. It simply shows
      how the
      smart_arg library can be used.

      No one should really try to use this
      program outside of those interested
      in using smart_arg in their own
      applications.'''),
    ExtendedHelp(
      'This is more extended text that can be put into its own section.',
      header: 'SECTION 2',
    ),
  ],
)
class Args extends SmartArg {
  @Group(
    name: 'Group 1',
    beforeHelp: '''
    This is some long text that explains this section in detail. Blah blah blah
    blah blah blah blah blah. This will be wrapped as needed. Thus, it will
    display beautifully in the console.
  ''',
    afterHelp:
        'This is just a single sentence but even it will be wrapped if necessary',
  )
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

  @Group(
    name: 'Group 2 -- OTHER',
    beforeHelp: 'Help before',
    afterHelp: 'Help after',
  )
  @IntegerArgument(
    help: 'Count of times to say hello',
  )
  int count;

  @DoubleArgument(
    help:
        'Some other silly parameter to show double parsing. This also has a very long description that should word wrap in the output and produce beautiful display.',
  )
  double silly;

  @BooleanArgument(
    short: 'v',
    help: '''Turn verbose mode on.

    This is an example also of using multi-line help text that is formatted
    inside of the editor. This should be one paragraph. I'll add some more
    content here. This will be the last sentence of the first paragraph.

    This is another paragraph formatted very
    narrowly in the code editor. Does it
    look the same as the one above? I sure
    hope that it does. It would make help
    display very easy to implement.
    ''',
    isNegateable: true,
  )
  bool verbose = false;

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

  print('header  : ${args.header}');
  print('filename: ${args.filename}');
  print('verbose : ${args.verbose}');
  print('count   : ${args.count}');
  print('silly   : ${args.silly}');
  print('names   : ${args.names?.join(', ')}');
  print('extras  : ${args.extras.join(' ')}');
}
