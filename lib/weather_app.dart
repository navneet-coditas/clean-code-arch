import 'package:clean_code_asses/weather_home_page.dart';
import 'package:flutter/material.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather Forecast',
      home: WeatherHomePage(),
    );
  }
}
