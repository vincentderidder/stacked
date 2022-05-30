import 'package:stacked_generator/src/generators/forms/form_generator_util.dart';
import 'package:stacked_generator/src/generators/forms/form_view_config.dart';

/// A generator that creates the form code based on the configs passed in
class StackedFormContentGenerator {
  final FormViewConfig _formViewConfig;
   late FormGeneratorUtil _util;
  StackedFormContentGenerator(this._formViewConfig);

  String generate() {
    _util = FormGeneratorUtil(formViewConfig: _formViewConfig);
    return _util.generate();
  }
}
