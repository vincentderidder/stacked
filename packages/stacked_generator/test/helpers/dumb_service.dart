import 'package:stacked_core/stacked_core.dart';

abstract class AbstractDumpService {}

class DumpService implements AbstractDumpService {
  String? name;
  int? value;
  static DumpService? _instance;

  static DumpService getInstance() {
    if (_instance == null) {
      _instance = DumpService();
    }

    return _instance!;
  }

  static Future<DumpService> presolve() async {
    if (_instance == null) {
      _instance = DumpService();
    }

    return _instance!;
  }

  static disposee(String) {}
}

class DumpServiceWithOneParam {
  final String? name;
  final int? value;
  const DumpServiceWithOneParam({
    @factoryParam this.name,
    this.value,
  });
}

class DumpServiceWithParams {
  final String? name;
  final int? value;
  const DumpServiceWithParams({
    @factoryParam this.name,
    @factoryParam this.value,
  });
}
