import 'package:flutter/material.dart';
import '../models/weather_forecast_model.dart';

class WeatherForecastWidget extends StatelessWidget {
  final WeatherForecast forecast;

  const WeatherForecastWidget({
    Key? key,
    required this.forecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get only first 5 days for simplicity
    final dailyForecasts = forecast.dailyForecasts.take(5).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '5-Day Forecast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            ...dailyForecasts.map((daily) => _buildForecastItem(daily)),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastItem(DailyForecast daily) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Day and Date
          Expanded(
            flex: 2,
            child: Text(
              '${daily.getDayName()}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Weather Icon
          Expanded(
            flex: 1,
            child: Text(
              daily.getWeatherIcon(),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Temperature
          Expanded(
            flex: 2,
            child: Text(
              '${daily.temperature.round()}°C',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          
          // Weather Details
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '💧 ${daily.humidity}%',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(
                  '💨 ${daily.windSpeed} m/s',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}