/// Annotation class to provide additional hints on parsing a particular property.

abstract class Argument {
  /// Short version, if any, that can be used for this property.
  ///
  /// Long option will be the name of the property, the short option will be
  /// an alias of the long option.
  ///
  /// ```
  /// @Parameter(short: 'n')
  /// String name;
  /// ```
  ///
  /// With the above configuration, the `name` property can be set on the command
  /// line by using --name John, --name=John, -n John or -n=John.
  final String short;

  /// Long key, if any, that can be used for this property.
  ///
  /// * Set to false if no long key is desired.
  /// * Leave empty to make the long key the same as the class variable.
  /// * Set to a string to use instead of the class variable name. The class
  ///   variable name will be translated from camel case to a dashed string.
  ///   i.e. multiWordParameter would translate to the command line option
  ///   --multi-word-parameter.
  final dynamic long;

  /// Description of the property to be used in the help output.
  final String help;

  /// Is this option required?
  ///
  /// If this is set to `true` and it is not supplied, the user will be told
  /// there is an error, will be shown the help screen and if
  /// [SmartArgApp.exitOnFailure] is set to `true`, the application will exit
  /// with the error code 1.
  final bool isRequired;

  /// Environment Variable, if any, that can be used for this property.
  final String environmentVariable;

  const Argument({
    this.short,
    this.long,
    this.help,
    this.isRequired = false,
    this.environmentVariable,
  });

  List<String> specialKeys(String short, String long) {
    return [];
  }

  dynamic handleValue(String key, dynamic value);

  bool get needsValue => true;

  List<String> get additionalHelpLines => [];
}
