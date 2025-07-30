class AppConfig {
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');
  static const bool debugMode = bool.fromEnvironment('DEBUG_MODE');
}
