library test.smart_arg;

import 'annotations/boolean_argument_test.dart' as boolean_argument_test;
import 'annotations/command_test.dart' as command_test;
import 'annotations/directory_argument_test.dart' as directory_argument_test;
import 'annotations/double_argument_test.dart' as double_argument_test;
import 'annotations/extended_help_test.dart' as extended_help_test;
import 'annotations/file_argument_test.dart' as file_argument_test;
import 'annotations/group_test.dart' as group_test;
import 'annotations/help_argument_test.dart' as help_argument_test;
import 'annotations/integer_argument_test.dart' as integer_argument_test;
import 'annotations/parse_test.dart' as parse_test;
import 'annotations/string_argument_test.dart' as string_argument_test;

import 'smart_arg/smart_arg_test.dart' as smart_arg_test;
import 'smart_arg/command_parsing_test.dart' as command_parsing_test;
import 'string_utils_test.dart' as string_utils_test;

void main() {
  // Annotations
  boolean_argument_test.main();
  command_test.main();
  directory_argument_test.main();
  double_argument_test.main();
  extended_help_test.main();
  file_argument_test.main();
  group_test.main();
  help_argument_test.main();
  integer_argument_test.main();
  parse_test.main();
  string_argument_test.main();

  // Parser
  smart_arg_test.main();
  command_parsing_test.main();

  // Others
  string_utils_test.main();
}
