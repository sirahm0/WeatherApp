import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final weatherService = WeatherService();
  Weather? weather;
  bool isLoading = false;
  final TextEditingController cityController = TextEditingController();

  fetchWeather({required String cityName}) async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedWeather = await weatherService.getWeather(cityName);
      setState(() {
        weather = fetchedWeather;
      });
    } catch (e) {
      setState(() {
        weather = null;
      });
      print("Error fetching weather: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getWeatherAnimation(String mainCond) {
    switch (mainCond.toLowerCase()) {
      case "clouds":
        return 'assets/Cloudy.json';
      case "mist":
        return 'assets/Mist.json';
      case "clear":
        return 'assets/Sunny.json';
      case "rain":
        return 'assets/Sunny-rain.json';
      case "snow":
        return 'assets/Snow.json';
      case "thunderstorm":
        return 'assets/Thunder.json';
      default:
        return 'assets/Sunny-cloud.json';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather(cityName: "Jeddah"); // Default weather on app launch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 34, 52),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    hintText: "Enter City Name",
                    hintStyle: const TextStyle(color: Color.fromARGB(114, 255, 255, 255)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 22, 50, 72),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      fetchWeather(cityName: value);
                    }
                  },
                ),
                const SizedBox(height: 50),
                if (isLoading)
                  const CircularProgressIndicator()
                else if (weather == null)
                  const Text(
                    "Unable to fetch weather data.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 35,
                      ),
                      Text(
                        weather?.cityName ?? "City......",
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Lottie.asset(
                        getWeatherAnimation(weather?.mainCond ?? ""),
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${weather?.temp?.round().toString() ?? "0"}°",
                        style: const TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 100),
                      // ignore: prefer_const_constructors
                      Text(
                        "Made By Ahmed07",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
