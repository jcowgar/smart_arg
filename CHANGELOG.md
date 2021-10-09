## 1.2.0

- Added support for reading arguments from Environment Variables if not provided during parsing
- Added extra methods to `SmartArg` for handling lifecycle operations:
  - `beforeCommandParse`
  - `beforeCommandExecute`
  - `afterCommandExecute`
- Upgraded dev_dependencies
  - test to `^1.18.2`
  - build_runner to `^2.1.4`
  - build_test to `^2.1.4`
  - Replaced pandantic with lints `^1.0.1`
- Upgraded dependencies
  - reflectable to `3.0.4`
- Fixed various linter warnings
- Fixed support for non-annotated properties on commands and SmartArgs
- Upgraded for Null Type Safety

## 1.1.2

- Updated dependencies pedantic, test, path, build_runner, build_test and reflectable
- Fixed new linting errors "unnecessary_brace_in_string_interps"

## 1.1.1

- Fixed linting errors from dartanalyzer
- Updated reflectable to 2.2.1

## 1.1.0

- Moved from dart:mirrors to source generation using reflectable

## 1.0.0+1

- Updated description in pubspec.yaml due to pub.dev Maintenance suggestions.

## 1.0.0

- Initial version
