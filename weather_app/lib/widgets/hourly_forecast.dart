import 'package:flutter/material.dart';
import '../models/weather_forecast_model.dart';

class HourlyForecast extends StatelessWidget {
  final WeatherForecast forecast;

  const HourlyForecast({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get next 12 hours of forecast
    final hourly = forecast.dailyForecasts.take(12).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hourly Forecast',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hourly.length,
                  itemBuilder: (context, index) {
                    final hour = hourly[index];
                    return _buildHourItem(context, hour, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHourItem(BuildContext context, DailyForecast hour, int index) {
    final time = index == 0 ? 'Now' : '${hour.date.hour}:00';
    
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: index == 11 ? 0 : 12),
      child: Column(
        children: [
          Text(
            time,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            hour.getWeatherIcon(),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            '${hour.temperature.round()}°',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}