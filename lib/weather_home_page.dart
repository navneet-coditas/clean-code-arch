import 'package:clean_code_asses/service/weather_service.dart';
import 'package:flutter/material.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
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
            _buildTextFiled(),
            _buildButton(),
            if (_errorMessage != null) ...[
              _buildErrorText(),
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

  Text _buildErrorText() =>
      Text(_errorMessage!, style: const TextStyle(color: Colors.red));

  ElevatedButton _buildButton() {
    return ElevatedButton(
      onPressed: _getWeather,
      child: const Text('Get Weather'),
    );
  }

  TextField _buildTextFiled() {
    return TextField(
      decoration: const InputDecoration(labelText: 'Enter location'),
      onChanged: (value) {
        _location = value;
      },
    );
  }
}
