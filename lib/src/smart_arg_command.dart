import 'smart_arg.dart';

abstract class SmartArgCommand extends SmartArg {
  void execute(SmartArg parentArguments);
}
