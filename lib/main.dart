import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService _weatherService = WeatherService();
  String _location = '';
  Map<String, dynamic>? _currentWeather;
  List<dynamic>? _forecast;
  String? _errorMessage;

  void _getWeather() async {
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
                _location = value;
              },
            ),
            ElevatedButton(
              onPressed: _getWeather,
              child: const Text('Get Weather'),
            ),
            if (_errorMessage != null) ...[
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            if (_currentWeather != null) ...[
              Text('Current Weather: ${_currentWeather!['main']['temp']}°C'),
              Text(
                  'Condition: ${_currentWeather!['weather'][0]['description']}'),
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
                          '${forecastItem['dt_txt']} - ${forecastItem['main']['temp']}°C'),
                      subtitle: Text(forecastItem['weather'][0]['description']),
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

class WeatherService {
  final String apiKey =
      'abbbdc53df4bac76343fa3493c8fd77f'; // Replace with your OpenWeatherMap API key

  Future<Map<String, dynamic>> fetchCurrentWeather(String location) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<dynamic>> fetchWeatherForecast(String location) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['list'];
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }
}
