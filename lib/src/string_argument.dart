import 'argument.dart';

class StringArgument extends Argument {
  /// Parameter must be one of the items in the list.
  final List<dynamic> mustBeOneOf;

  const StringArgument({
    String short,
    dynamic long,
    String help,
    bool isRequired,
    this.mustBeOneOf,
  }) : super(
          short: short,
          long: long,
          help: help,
          isRequired: isRequired,
        );

  @override
  dynamic handleValue(String key, dynamic value) {
    if (mustBeOneOf != null && mustBeOneOf.contains(value) == false) {
      var oneOfDisplay = mustBeOneOf.map((v) => v.toString()).join(', ');
      throw ArgumentError('$key must be one of $oneOfDisplay');
    }

    return value;
  }

  @override
  List<String> get additionalHelpLines {
    List<String> result = [];

    if (mustBeOneOf != null) {
      var oneOfList = mustBeOneOf.map((v) => v.toString()).join(', ');
      result.add('must be one of $oneOfList');
    }

    return result;
  }

  List<String> get emptyList => [];
}
