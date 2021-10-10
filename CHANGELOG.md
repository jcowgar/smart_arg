## 2.0.0

- Breaking:
  - Upgraded for Null Type Safety. Requires minimum Dart version `2.12.0`
  - Upgraded reflectable to `3.0.4`
- Added:
  - Support for reading arguments from Environment Variables if not provided during parsing
  - Extra methods to `SmartArg` for handling lifecycle operations. Useful for DI instantiation
    - `beforeCommandParse`
    - `beforeCommandExecute`
    - `afterCommandExecute`
- Fixed:
  - Various linter warnings
  - Support for non-annotated properties on commands and SmartArgs
- Other:
  - Upgraded dev_dependencies
    - test to `^1.18.2`
    - build_runner to `^2.1.4`
    - build_test to `^2.1.4`
  - Replaced pandantic with lints `^1.0.1`

## 1.1.2

- Updated dependencies pedantic, test, path, build_runner, build_test and reflectable
- Fixed new linting errors "unnecessary_brace_in_string_interps"

## 1.1.1

- Fixed linting errors from dartanalyzer
- Updated reflectable to `2.2.1`

## 1.1.0

- Moved from dart:mirrors to source generation using reflectable

## 1.0.0+1

- Updated description in pubspec.yaml due to pub.dev Maintenance suggestions.

## 1.0.0

- Initial version
