# weather_app

The Project for the third day of the flutter workshop presented by the programming club

### Used Packages
lottie: https://pub.dev/packages/lottie
http: https://pub.dev/packages/http

# Project Structure
```
weather_app/
├── lib/
│   ├── main.dart
│   ├── pages/
│   │   └── weather_page.dart
│   ├── services/
│   │   └── weather_service.dart
│   ├── models/
│       └── weather_model.dart
|
├── assets/
│   ├── cloud.json
│   ├── sunny.json
│   ├── rainy.json
│   ├── thunder.json
|
└── pubspec.yaml
```
## Screenshot
<img src="assets/screenshot.png" width="270" height="600">

# files contents
## main.dart
```
import 'package:flutter/material.dart';
import 'pages/weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}
```
## weather_model.dart
```
class Weather {
  final String cityName;
  final double temp;
  final String mainCond;

  Weather({required this.cityName, required this.temp, required this.mainCond});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temp: json['main']['temp'],
      mainCond: json['weather'][0]['main'],
    );
  }
}
```
## weather_service.dart
```
class WeatherService {
  static String BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  static String API = 'YOUR_API_KEY';
  WeatherService();

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$API&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load weather data');
    }
  }
}
```
## weather_page.dart
### variables
```
  final weatherSerivce = WeatherService();
  Weather? weather;
```
### fetchWeather
```
  fetchWeather({String cityName = "jeddah"}) async {
    try {
      final getweather = await weatherSerivce.getWeather(cityName);
      setState(() {
        weather = getweather;
      });
    } catch (e) {
      print(e);
    }
  }
```
### initState
```
  @override
  void initState() {
    super.initState();
    fetchWeather();
  }
```
### getWeatherAnimation
```
  String getWeatherAnimation(String mainCond) {
    switch (mainCond) {
      case "Clear":
        return 'assets/sunny.json';
      case "Clouds":
        return 'assets/cloud.json';
      case "Rain":
        return 'assets/rainy.json';
      case "Thunderstorm":
        return 'assets/thunder.json';
      default:
        return 'assets/sunny.json';
    }
  }
```
### The first column
```
      Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 35,
                  ),
                  Text(
                    weather?.cityName ?? "City...",
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
```
### the second column
```
      Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    getWeatherAnimation(weather?.mainCond ?? "clouds"),
                  ),
                  Text(
                    "${weather?.temp.round().toString()}°",
                    style: const TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
```







