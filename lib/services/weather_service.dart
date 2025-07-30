import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:vguard/models/weather_data.dart';

class WeatherService {
  /// final String apiKey = dotenv.env['_weatherApiKey'] ?? '';
  static final String _apiKey = dotenv.env['_weatherApiKey'] ?? '';

  ///replace
  static final String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData> fetchWeatherData(
    double latitude,
    double longitude,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
    ); // units=metric for Celsius

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception(
          'Failed to load weather data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  // Helper to determine growth status based on weather
  String getGrowthStatus(WeatherData weather) {
    if (weather.temperature >= 20 &&
        weather.temperature <= 30 &&
        weather.humidity >= 60 &&
        weather.humidity <= 80 &&
        weather.windSpeed < 5 &&
        weather.cloudiness < 70) {
      return 'Optimal';
    } else if (weather.temperature > 30 ||
        weather.temperature < 15 ||
        weather.humidity < 40 ||
        weather.humidity > 90) {
      return 'Challenging';
    }
    return 'Good';
  }

  // Helper to determine disease risk based on weather
  String getDiseaseRisk(WeatherData weather) {
    if (weather.humidity > 80 &&
        weather.temperature >= 20 &&
        weather.temperature <= 30 &&
        (weather.weatherCondition == 'Rain' ||
            weather.weatherCondition == 'Clouds')) {
      return 'High';
    } else if (weather.humidity > 70 && weather.temperature > 15) {
      return 'Medium';
    }
    return 'Low';
  }

  // Helper to determine overall status
  String getOverallStatus(WeatherData weather) {
    final growth = getGrowthStatus(weather);
    final diseaseRisk = getDiseaseRisk(weather);

    if (growth == 'Optimal' && diseaseRisk == 'Low') {
      return 'Optimal';
    } else if (growth == 'Challenging' || diseaseRisk == 'High') {
      return 'Adverse';
    }
    return 'Moderate';
  }
}
