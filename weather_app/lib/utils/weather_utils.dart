import 'package:flutter/material.dart';

class WeatherUtils {
  static Color getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Colors.orange;
      case 'clouds':
        return Colors.blueGrey;
      case 'rain':
        return Colors.indigo;
      case 'drizzle':
        return Colors.blue;
      case 'thunderstorm':
        return Colors.purple;
      case 'snow':
        return Colors.cyan;
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'sand':
      case 'ash':
        return Colors.grey;
      case 'squall':
      case 'tornado':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  static LinearGradient getWeatherGradient(String condition) {
    final Color primaryColor = getWeatherColor(condition);
    final Color secondaryColor = primaryColor.withOpacity(0.7);

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [primaryColor, secondaryColor],
    );
  }

  static String getWeatherAnimation(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
        return '🌫️';
      default:
        return '🌈';
    }
  }
}
