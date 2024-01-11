import 'dart:convert';

import 'package:http/http.dart' as http;

Future<WeatherInfo> fetchWeather(String city) async {
  final cityToCoordsResponse = await http.get(Uri.parse("https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=en&format=json"));

  if (cityToCoordsResponse.statusCode == 200) {
    var cityToCoords = jsonDecode(cityToCoordsResponse.body);
    final cityItem = cityToCoords['results'][0];
    double lat = cityItem['latitude'];
    double long = cityItem['longitude'];

    final weatherResponse = await http.get(Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current=temperature_2m,wind_speed_10m&forecast_days=1"));

    if (weatherResponse.statusCode == 200) {
      return WeatherInfo.fromJson(jsonDecode(weatherResponse.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to load WeatherInfo. Status code: ${weatherResponse.statusCode}, response: ${weatherResponse.body}.");
    }
  } else {
    throw Exception("Failed to load WeatherInfo. Status code: ${cityToCoordsResponse.statusCode}, response: ${cityToCoordsResponse.body}.");
  }
}


class WeatherInfo {

  final double temperature;
  final double wind;

  const WeatherInfo({
    required this.temperature,
    required this.wind,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return switch(json["current"]) {
      {
        "temperature_2m": double temperature,
        "wind_speed_10m": double wind,
      } =>
          WeatherInfo(
            temperature: temperature,
            wind: wind,
          ),
      _ =>
      throw const FormatException(
          "Failed to load JSON response for WeatherInfo."),
    };
  }

  @override
  String toString(){
    return "WeatherInfo(temperature: $temperature, wind: $wind)";
  }
}

