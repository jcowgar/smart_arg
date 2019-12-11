import 'boolean_argument.dart';

class HelpArgument extends BooleanArgument {
  const HelpArgument() : super(short: 'h', help: 'Show help');

  @override
  List<String> specialKeys(String short, String long) {
    return ['-?'];
  }
}
