import 'package:clean_code_asses/modal/weather.dart';
import 'package:clean_code_asses/service/weather_service.dart';
import 'package:flutter/material.dart';

/// A StatefulWidget that displays the weather home page.
class WeatherHomePage extends StatefulWidget {
  /// Creates a WeatherHomePage.
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

/// The state of the WeatherHomePage.
class _WeatherHomePageState extends State<WeatherHomePage> {
  /// The service used to fetch weather data.
  final WeatherService _weatherService = WeatherService();

  /// The current location entered by the user.
  String _location = '';

  /// The current weather data.
  Weather? _currentWeather;

  /// The weather forecast data.
  List<Weather>? _forecast;

  /// The error message to display if there's an error.
  String? _errorMessage;

  /// Fetches and sets the current weather and forecast for the given location.
  Future<void> _fetchAndSetWeather() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      final currentWeather =
          await _weatherService.fetchCurrentWeather(_location);
      final forecast = await _weatherService.fetchWeatherForecast(_location);
      setState(() {
        _currentWeather = currentWeather;
        _forecast = forecast;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Forecast')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Enter location'),
              onChanged: (value) {
                setState(() {
                  _location = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _fetchAndSetWeather,
              child: const Text('Get Weather'),
            ),
            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            if (_currentWeather != null) ...[
              Text('Current Weather: ${_currentWeather?.temperature}°C'),
              Text('Condition: ${_currentWeather?.description}'),
            ],
            if (_forecast != null) ...[
              const Text('5-Day Forecast:'),
              Expanded(
                child: ListView.builder(
                  itemCount: _forecast!.length,
                  itemBuilder: (context, index) {
                    final forecastItem = _forecast![index];
                    return ListTile(
                      title: Text(
                          '${forecastItem.description} - ${forecastItem.temperature}°C'),
                      subtitle: Text(forecastItem.description),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
