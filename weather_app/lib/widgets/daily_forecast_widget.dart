import 'package:flutter/material.dart';
import '../models/weather_forecast_model.dart';

class DailyForecastWidget extends StatelessWidget {
  final WeatherForecast forecast;

  const DailyForecastWidget({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get 5-day forecast (every 8th item for daily)
    final daily = forecast.dailyForecasts.where((item) => forecast.dailyForecasts.indexOf(item) % 8 == 0).take(5).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '5-Day Forecast',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              ...daily.map((day) => _buildDayItem(context, day)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayItem(BuildContext context, DailyForecast day) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              day.getDayName(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              day.getWeatherIcon(),
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${day.humidity}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${day.temperature.round()}°',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}