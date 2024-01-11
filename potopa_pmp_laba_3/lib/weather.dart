import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:potopa_pmp_laba_3/db.dart';

Future<WeatherInfo> fetchWeather(String city) async {
  try {
    final cityToCoordsResponse = await http.get(Uri.parse("https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=en&format=json"));

    if (cityToCoordsResponse.statusCode == 200) {
      var cityToCoords = jsonDecode(cityToCoordsResponse.body);
      final cityItem = cityToCoords['results'][0];
      double lat = cityItem['latitude'];
      double long = cityItem['longitude'];

      final weatherResponse = await http.get(Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current=temperature_2m,wind_speed_10m&forecast_days=1"));

      if (weatherResponse.statusCode == 200) {
        final w = WeatherInfo.fromJson(
            city, jsonDecode(weatherResponse.body) as Map<String, dynamic>);

        await insertWeather(w);

        return w;
      } else {
        return await getWeather(city);
      }
    } else {
      return await getWeather(city);
    }
  } on Exception catch(e) {
    return await getWeather(city);
  }
}


class WeatherInfo {
  final String id;
  final double temperature;
  final double wind;

  const WeatherInfo({
    required this.id,
    required this.temperature,
    required this.wind,
  });

  factory WeatherInfo.fromJson(String id, Map<String, dynamic> json) {
    return switch(json["current"]) {
      {
      "temperature_2m": double temperature,
      "wind_speed_10m": double wind,
      } =>
          WeatherInfo(
            id: id,
            temperature: temperature,
            wind: wind,
          ),
      _ =>
      throw const FormatException(
          "Failed to load JSON response for WeatherInfo."),
    };
  }

  factory WeatherInfo.fromDb(Map<String, dynamic> keys) {
    return switch(keys) {
      {
      "id": String id,
      "temperature": String temperature,
      "wind": String wind,
      } =>
          WeatherInfo(
            id: id,
            temperature: double.parse(temperature),
            wind: double.parse(wind),
          ),
      _ =>
      throw const FormatException(
          "Failed to load db entry for WeatherInfo."),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'temperature': temperature,
      'wind': wind,
    };
  }

  @override
  String toString(){
    return "WeatherInfo(temperature: $temperature, wind: $wind)";
  }
}
