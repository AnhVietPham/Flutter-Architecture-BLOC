class BaseModel {
  static String parseString(String jsonKey, Map<String, dynamic> json) {
    return json[jsonKey] ?? '';
  }

  static bool parseBool(String jsonKey, Map<String, dynamic> json) {
    return json[jsonKey] ?? false;
  }

  static int parseInt(String jsonKey, Map<String, dynamic> json) {
    return json[jsonKey] ?? 0;
  }

  static double parseDouble(String jsonKey, Map<String, dynamic> json) {
    return json[jsonKey] ?? 0.0;
  }
}
