class Weather {
  final double temperature;
  final String description;

  Weather({required this.temperature, required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        temperature: json['main']['temp'].toDouble(),
        description: json['weather'][0]['description'],
      );
}
