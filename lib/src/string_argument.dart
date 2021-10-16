import 'argument.dart';

class StringArgument extends Argument {
  /// Parameter must be one of the items in the list.
  final List<dynamic>? mustBeOneOf;

  const StringArgument({
    String? short,
    dynamic long,
    String? help,
    bool? isRequired,
    this.mustBeOneOf,
    String? environmentVariable,
  }) : super(
          short: short,
          long: long,
          help: help,
          isRequired: isRequired,
          environmentVariable: environmentVariable,
        );

  @override
  dynamic handleValue(String? key, dynamic value) {
    if (mustBeOneOf != null && mustBeOneOf!.contains(value) == false) {
      var oneOfDisplay = mustBeOneOf!.map((v) => v.toString()).join(', ');
      throw ArgumentError('$key must be one of $oneOfDisplay');
    }

    return value;
  }

  @override
  List<String> get additionalHelpLines {
    // Local type is needed, otherwise result winds up being a
    // List<dynamic> which is incompatible with the return type.
    // Therefore, ignore the suggestion from dartanalyzer
    //
    // ignore: omit_local_variable_types
    List<String> result = [];

    if (mustBeOneOf != null) {
      var oneOfList = mustBeOneOf!.map((v) => v.toString()).join(', ');
      result.add('must be one of $oneOfList');
    }

    return result;
  }

  List<String> get emptyList => [];
}
