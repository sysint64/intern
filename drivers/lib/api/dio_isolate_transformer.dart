import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:serdes_json/serdes_json.dart';

/// Parse json in isolate using compute
class DioIsolateTransformer extends DefaultTransformer {
  DioIsolateTransformer() : super(jsonDecodeCallback: _parseJson);
}

dynamic _parseAndDecode(String response) {
  return jsonDecode(response);
}

dynamic _parseJson(String text) {
  return compute<String, dynamic>(_parseAndDecode, text);
}
