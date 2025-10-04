class WeatherForecast {
  final List<DailyForecast> dailyForecasts;

  WeatherForecast({required this.dailyForecasts});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'];
    return WeatherForecast(
      dailyForecasts: list.map((item) => DailyForecast.fromJson(item)).toList(),
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double temperature;
  final String condition;
  final int conditionId;
  final int humidity;
  final double windSpeed;

  DailyForecast({
    required this.date,
    required this.temperature,
    required this.condition,
    required this.conditionId,
    required this.humidity,
    required this.windSpeed,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      conditionId: json['weather'][0]['id'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }

  String getWeatherIcon() {
    if (conditionId < 300) {
      return '🌩️';
    } else if (conditionId < 400) {
      return '🌧️';
    } else if (conditionId < 600) {
      return '☔';
    } else if (conditionId < 700) {
      return '☃️';
    } else if (conditionId < 800) {
      return '🌫️';
    } else if (conditionId == 800) {
      return '☀️';
    } else if (conditionId <= 804) {
      return '☁️';
    } else {
      return '🤷';
    }
  }

  String getDayName() {
    return _getDayOfWeek(date.weekday);
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}