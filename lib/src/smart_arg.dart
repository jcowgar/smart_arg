import 'dart:io';
import 'dart:math';

import 'package:reflectable/reflectable.dart';

import 'argument.dart';
import 'command.dart';
import 'group.dart';
import 'help_argument.dart';
import 'mirror_argument_pair.dart';
import 'parser.dart';
import 'smart_arg_command.dart';
import 'string_utils.dart';

import 'reflector.dart';

// Local type is needed for strict type checking in lists.
// var abc = [] turns out to be a List<dynamic> which is not
// as safe as List<String> abc = [] for example.
//
// This file uses a lot of lists, therefore the\
// omit_local_variable_types linting rule is disabled globally
// for this file.
//
// ignore_for_file: omit_local_variable_types

/// Base class for the [SmartArg] parser.
///
/// Your application should extend [SmartArg], add public properties,
/// and call the [SmartArg.parse()] method on your class.
class SmartArg {
  static const reflectable = Reflector.reflector;

  //
  // Public API
  //

  /// List of extras supplied on the command line.
  ///
  /// Extras are anything supplied on the command line that was not an option.
  List<String> get extras => _extras;

  SmartArg() {
    final instanceMirror = reflectable.reflect(this);

    // Find our app meta data (if any)
    _app = instanceMirror.type.metadata.firstWhere((m) => m is Parser);

    // Build an easy to use lookup for arguments on the command line
    // to their cooresponding Parameter configurations.
    _values = {};
    _commands = {};
    _mirrorParameterPairs = [];

    {
      var currentGroup;

      for (final mirror in instanceMirror.type.declarations.values
          .where((p) => p is VariableMirror && p.isPrivate == false)) {
        currentGroup =
            mirror.metadata.firstWhere((m) => m is Group, orElse: () => null) ??
                currentGroup;

        final parameter = mirror.metadata.firstWhere((m) => m is Argument);
        final mpp = MirrorParameterPair(mirror, parameter, currentGroup);

        for (final key in mpp.keys(_app)) {
          if (_values.containsKey(key)) {
            throw StateError('$key was configured multiple times');
          }

          _values[key] = mpp;
        }

        _mirrorParameterPairs.add(mpp);

        if (parameter is Command) {
          _commands[mpp.displayKey] = mpp;
        }
      }
    }
  }

  /// Parse the [arguments] list populating properties on the [SmartArg] class.
  ///
  /// If [Parser.exitOnFailure] is set to true, this function will call
  /// `exit(1)` if there is a command line parsing error. It will do so only
  /// after telling the user what the error was and displaying the result of
  /// [usage()].
  void parse(List<String> arguments) {
    _resetParser();

    try {
      if (_parse(arguments)) {
        _validate();
      }
    } on ArgumentError catch (e) {
      if (_app?.exitOnFailure == true) {
        print(e.toString());
        print('');
        print(usage());
        exit(1);
      }

      rethrow;
    }
  }

  /// Return a string telling the user how to use your application from the command line.
  String usage() {
    List<String> lines = [];

    if (_app?.description != null) {
      lines.add(_app.description);
      lines.add('');
    }

    List<String> helpKeys = [];
    List<Group> helpGroups = [];
    List<List<String>> helpDescriptions = [];

    final arguments =
        _mirrorParameterPairs.where((v) => v.argument is Command == false);
    final commands = _mirrorParameterPairs.where((v) => v.argument is Command);

    if (arguments.isNotEmpty) {
      for (var mpp in arguments) {
        List<String> keys = [];

        keys.addAll(mpp.keys(_app).map((v) => v.startsWith('-') ? v : '--$v'));
        helpKeys.add(keys.join(', '));
        helpGroups.add(mpp.group);

        List<String> helpLines = [mpp.argument.help ?? 'no help available'];

        if (mpp.argument.isRequired ?? false) {
          helpLines.add('[REQUIRED]');
        }

        helpLines.addAll(mpp.argument.additionalHelpLines);

        helpDescriptions.add(helpLines);
      }
    }

    const lineWidth = 78; // TODO: Can we get this from the terminal?
    const lineIndent = 2;
    const maxKeyLenAllowed = 25; // Will include indent
    final linePrefix = ' ' * lineIndent;

    final maxKeyLen = helpKeys.fold<int>(
        0,
        (a, b) => (b.length + lineIndent) > a &&
                (b.length + lineIndent) < maxKeyLenAllowed
            ? (b.length + lineIndent)
            : a);
    final keyPadWidth = min(maxKeyLenAllowed, maxKeyLen + 1);

    {
      final trailingHelp = (Group group) {
        if (group?.afterHelp != null) {
          lines.add('');
          lines.add(indent(
              hardWrap(group.afterHelp, lineWidth - lineIndent), lineIndent));
        }
      };

      var currentGroup;

      for (var i = 0; i < helpKeys.length; i++) {
        final thisGroup = helpGroups[i];

        if (thisGroup != currentGroup) {
          trailingHelp(currentGroup);

          if (currentGroup != null) {
            lines.add('');
          }

          lines.add(thisGroup.name);

          if (thisGroup.beforeHelp != null) {
            lines.add(indent(
                hardWrap(thisGroup.beforeHelp, lineWidth - lineIndent),
                lineIndent));
            lines.add('');
          }
        }

        var keyDisplay =
            linePrefix + helpKeys[i].padRight(keyPadWidth - lineIndent);

        var thisHelpDescriptions = helpDescriptions[i].join('\n');
        thisHelpDescriptions =
            hardWrap(thisHelpDescriptions, lineWidth - keyPadWidth);
        thisHelpDescriptions = indent(thisHelpDescriptions, keyPadWidth);

        if (keyDisplay.length == keyPadWidth) {
          thisHelpDescriptions =
              thisHelpDescriptions.replaceRange(0, keyPadWidth, keyDisplay);
        } else {
          lines.add(keyDisplay);
        }

        lines.add(thisHelpDescriptions);

        currentGroup = helpGroups[i] ?? currentGroup;
      }

      trailingHelp(currentGroup);
    }

    if (commands.isNotEmpty) {
      lines.add('');
      lines.add('COMMANDS');

      final maxCommandLength =
          commands.fold(0, (int a, b) => max(a, b.displayKey.length));

      for (var mpp in commands) {
        final key = mpp.displayKey.padRight(maxCommandLength + 1);
        final help = mpp.argument.help ?? '';
        final displayString = '$key $help';

        lines.add(indent(hardWrap(displayString, lineWidth), 2));
      }
    }

    if (_app?.extendedHelp != null) {
      for (final eh in _app.extendedHelp) {
        if (eh.help == null) {
          throw StateError('Help.help must be set');
        }

        lines.add('');

        if (eh.header != null) {
          lines.add(hardWrap(eh.header, lineWidth));
          lines.add(
              indent(hardWrap(eh.help, lineWidth - lineIndent), lineIndent));
        } else {
          lines.add(hardWrap(eh.help, lineWidth));
        }
      }
    }

    return lines.join('\n');
  }

  //
  // Private API
  //

  Parser _app;
  Map<String, MirrorParameterPair> _values;
  Map<String, MirrorParameterPair> _commands;
  List<String> _extras;
  Set<String> _wasSet;

  // tracked so we can have a proper order for help output
  List<MirrorParameterPair> _mirrorParameterPairs;

  bool _isStacked(String value) {
    final isSingleDash = value.startsWith('-') && !value.startsWith('--');
    final isLongerThanShort = value.length > 2;
    final isAssignment = isLongerThanShort && value.substring(2, 3) == '=';

    return isSingleDash && !isAssignment && isLongerThanShort;
  }

  List<String> _rewriteArguments(List<String> arguments) {
    List<String> result = [];
    for (final arg in arguments) {
      if (_isStacked(arg)) {
        final individualArgs = arg.split('').skip(1).map((v) => '-$v').toList();

        result.addAll(individualArgs);
      } else {
        result.add(arg);
      }
    }

    return result;
  }

  bool _parse(List<String> arguments) {
    final instanceMirror = reflectable.reflect(this);
    final List<String> expandedArguments = _rewriteArguments(arguments);

    int argumentIndex = 0;
    while (argumentIndex < expandedArguments.length) {
      var argument = expandedArguments[argumentIndex];
      var originalArgument = argument;

      argumentIndex++;

      if (argument.toLowerCase() == _app.argumentTerminator?.toLowerCase()) {
        _extras.addAll(expandedArguments.skip(argumentIndex));
        return true;
      } else if (argument.startsWith('-') == false) {
        if (_commands.containsKey(argument)) {
          final command = _commands[argument];
          final commandArguments = arguments.skip(argumentIndex).toList();

          _launchCommand(command, commandArguments);

          return true;
        } else {
          // Was not an argument, must be an extra
          _extras.add(argument);

          if (_app.allowTrailingArguments == false) {
            _extras.addAll(expandedArguments.skip(argumentIndex));
            return true;
          }

          continue;
        }
      }

      var argumentParts = argument.split('=');
      var argumentName = argumentParts.first;
      var hasValueViaEqual = argumentParts.length > 1;
      dynamic value = argumentParts.skip(1).join('=');

      if (argumentName.startsWith('--')) {
        argumentName = argumentName.substring(2);
      }

      // Find our argument configuration
      var argumentConfiguration = _values[argumentName];
      if (argumentConfiguration == null) {
        throw ArgumentError('$originalArgument is invalid');
      }

      if (argumentConfiguration.argument.needsValue && !hasValueViaEqual) {
        if (argumentIndex >= expandedArguments.length) {
          throw ArgumentError(
              '${argumentConfiguration.displayKey} expects a value but none was supplied.');
        }

        value = expandedArguments[argumentIndex];
        argumentIndex++;
      }

      value = argumentConfiguration.argument.handleValue(argumentName, value);

      // Try setting it as a list first
      var instanceValue =
          instanceMirror.invokeGetter(argumentConfiguration.mirror.simpleName);

      // There is no way of determining if a class variable is a list or not through
      // introspection, therefore we try to add the value as a list, or append to the
      // list first. If that fails, we assume it is not a list :-/

      if (instanceValue == null) {
        try {
          instanceValue = (argumentConfiguration.argument as dynamic).emptyList;
          (instanceValue as List).add(value);

          instanceMirror.invokeSetter(
              argumentConfiguration.mirror.simpleName, instanceValue);
          _wasSet.add(argumentConfiguration.displayKey);
        } catch (_) {
          // Adding as a list failed, so it must not be a list. Let's set it
          // as a normal value.
          instanceMirror.invokeSetter(
              argumentConfiguration.mirror.simpleName, value);
          _wasSet.add(argumentConfiguration.displayKey);
        }
      } else {
        try {
          // Since we can not determine if the instanceValue is a list or not...
          //
          // Just try the .first method to see if it exists. We don't really care
          // about the value, we just want to execute at least two methods on
          // the instance value to do as good of a job as we can to determine if
          // the type is a List or not.
          //
          // .first is the first method, .add will be the second
          var _ = (instanceValue as List).first;
          (instanceValue as List).add(value);
          _wasSet.add(argumentConfiguration.displayKey);
        } catch (_) {
          if (_wasSet.contains(argumentConfiguration.displayKey)) {
            throw ArgumentError(
                '${argumentConfiguration.displayKey} was supplied more than once');
          }

          // Adding as a list failed, so it must not be a list. Let's set it
          // as a normal value.
          instanceMirror.invokeSetter(
              argumentConfiguration.mirror.simpleName, value);
          _wasSet.add(argumentConfiguration.displayKey);
        }
      }

      if (argumentConfiguration.argument is HelpArgument) {
        _extras.addAll(expandedArguments.skip(argumentIndex));

        return false;
      }
    }

    return true;
  }

  void _validate() {
    // Check to see if we have any required arguments missing
    final List<String> isMissing = [];
    for (var mpp in _mirrorParameterPairs) {
      if (mpp.argument.isRequired == true &&
          _wasSet.contains(mpp.displayKey) == false) {
        isMissing.add(mpp.displayKey);
      }
    }

    if (isMissing.isNotEmpty) {
      throw ArgumentError(
          'missing required arguments: ${isMissing.join(', ')}');
    }

    if (_app.minimumExtras != null && extras.length < _app.minimumExtras) {
      throw ArgumentError(
          'expecting at least ${_app.minimumExtras} free form arguments but ${extras.length} was supplied');
    } else if (_app.maximumExtras != null &&
        extras.length > _app.maximumExtras) {
      throw ArgumentError(
          'expecting at most ${_app.maximumExtras} free form arguments but ${extras.length} was supplied');
    }
  }

  void _launchCommand(MirrorParameterPair commandMpp, List<String> arguments) {
    final a = commandMpp.mirror;
    final b = a.type as ClassMirror;
    final command = b.newInstance('', []) as SmartArgCommand;

    command.parse(arguments);
    command.execute(this);
  }

  void _resetParser() {
    _wasSet = {};
    _extras = [];
  }
}
