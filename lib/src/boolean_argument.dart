import 'argument.dart';

class BooleanArgument extends Argument {
  /// Can the flag be prefixed with 'no'?
  ///
  /// This will only make sense on boolean properties that have a default to true.
  ///
  /// ```
  /// @Parameter(isNegateable: true)
  /// bool verbose = true;
  /// ```
  ///
  /// On the command line, one can:
  ///
  /// | Command Line   | Result                  |
  /// | -------------- | ----------------------- |
  /// | empty          | `verbose` will be true  |
  /// | `--verbose`    | `verbose` will be true  |
  /// | `--no-verbose` | `verbose` will be false |
  final bool? isNegateable;

  const BooleanArgument({
    this.isNegateable,
    String? short,
    dynamic long,
    String? help,
    bool isRequired = false,
    String? environmentVariable,
  }) : super(
          short: short,
          long: long,
          help: help,
          isRequired: isRequired,
          environmentVariable: environmentVariable,
        );

  @override
  List<String> specialKeys(String? short, String? long) {
    if (isNegateable == true && long != null) {
      return ['no-$long'];
    }

    return [];
  }

  @override
  bool get needsValue => false;

  @override
  bool handleValue(String? key, dynamic value) => !key!.startsWith('no-');

  List<bool> get emptyList => [];
}
