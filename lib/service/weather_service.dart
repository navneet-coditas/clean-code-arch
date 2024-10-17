import 'dart:convert';
import 'package:clean_code_asses/modal/weather.dart';
import 'package:http/http.dart' as http;

/// A service class for fetching weather data from OpenWeatherMap API.
class WeatherService {
  /// The API key for OpenWeatherMap API. Replace with your actual API key.
  final String apiKey = 'abbbdc53df4bac76343fa3493c8fd77f';

  /// Fetches the current weather data for a given location.
  ///
  /// [location] The location for which to fetch the weather data.
  /// Returns a map of the decoded JSON response.
  Future<Weather> fetchCurrentWeather(String location) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  /// Fetches the weather forecast for a given location.
  ///
  /// [location] The location for which to fetch the weather forecast.
  /// Returns a list of the decoded JSON response.
  Future<List<Weather>> fetchWeatherForecast(String location) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['list'] as List)
          .map(
            (action) => Weather.fromJson(action),
          )
          .toList();
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }
}
