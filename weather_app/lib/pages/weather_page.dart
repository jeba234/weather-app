import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();

  WeatherModel? _weather;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await WeatherService.initialize();
      await _getLocationWeather();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize app: $e';
      });
    }
  }

  Future<void> _getLocationWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final position = await _locationService.getLocation();
      final weather = await _weatherService.getWeatherByLocation(
        position!.latitude,
        position.longitude,
      );
      
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get location weather: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchWeather(String cityName) async {
    if (cityName.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
        _searchController.clear();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get weather: $e';
        _isLoading = false;
      });
    }
  }

  void _retry() {
    if (_searchController.text.isNotEmpty) {
      _searchWeather(_searchController.text);
    } else {
      _getLocationWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getLocationWeather,
            tooltip: 'Refresh with current location',
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _errorMessage.isNotEmpty
              ? ErrorMessage(
                  message: _errorMessage,
                  onRetry: _retry,
                )
              : _buildWeatherContent(),
    );
  }

  Widget _buildWeatherContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Bar
          _buildSearchBar(),
          const SizedBox(height: 20),
          
          // Weather Display
          if (_weather != null) WeatherCard(weather: _weather!),
          
          // Welcome message when no weather data
          if (_weather == null) _buildWelcomeMessage(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search city...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: _searchWeather,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _searchWeather(_searchController.text),
            color: Colors.blue[700],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.cloud,
            size: 80,
            color: Colors.blue[300],
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome to Weather App!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Search for a city or allow location access to see current weather',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}