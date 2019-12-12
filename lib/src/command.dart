import 'argument.dart';

class Command extends Argument {
  const Command({
    String short,
    dynamic long,
    String help,
  }) : super(
          short: short,
          long: long,
          help: help,
        );

  @override
  void handleValue(String key, value) {}
}
