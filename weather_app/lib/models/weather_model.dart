class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int conditionId;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.conditionId,
  });

  // Factory method to create WeatherModel from JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      conditionId: json['weather'][0]['id'],
    );
  }

  // Method to get weather icon based on condition code
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

  // Method to get weather message based on temperature
  String getMessage() {
    if (temperature > 25) {
      return 'It\'s 🍦 time';
    } else if (temperature > 20) {
      return 'Time for shorts and 👕';
    } else if (temperature < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
