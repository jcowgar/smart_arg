import 'argument.dart';

class IntegerArgument extends Argument {
  /// Minimum number allowed, if any.
  final int? minimum;

  /// Maximum number allowed, if any.
  final int? maximum;

  const IntegerArgument({
    String? short,
    dynamic long,
    String? help,
    bool? isRequired,
    this.minimum,
    this.maximum,
  }) : super(
          short: short,
          long: long,
          help: help,
          isRequired: isRequired,
        );

  @override
  int? handleValue(String? key, dynamic value) {
    var result = int.tryParse(value);

    if (minimum != null && result! < minimum!) {
      throw ArgumentError('$key must be at least $minimum');
    }

    if (maximum != null && result! > maximum!) {
      throw ArgumentError('$key must be at most $maximum');
    }

    return result;
  }

  List<int> get emptyList => [];
}
