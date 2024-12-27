import 'dart:convert';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

// Handles API calls to OpenWeatherMap
class WeatherService {
  static const String BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  static const String API_KEY = ''; // Replace with your API key

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$API_KEY&units=metric'),
    );
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
