import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/weather_forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/favorites_service.dart';
import '../widgets/weather_header.dart';
import '../widgets/weather_details.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/daily_forecast_widget.dart'; // Updated import
import '../widgets/search_sheet.dart';
import '../utils/weather_utils.dart';
import 'favorites_page.dart';

class WeatherPage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const WeatherPage({
    Key? key, // Add this
    required this.onThemeToggle,
    required this.isDarkMode,
  }) : super(key: key); // Add super call

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with SingleTickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final FavoritesService _favoritesService = FavoritesService();
  
  WeatherModel? _weather;
  WeatherForecast? _forecast;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isFavorite = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      final forecast = await _weatherService.getWeatherForecastByLocation(
        position.latitude,
        position.longitude,
      );
      final isFavorite = await _favoritesService.isFavorite(weather.cityName);
      
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isFavorite = isFavorite;
        _isLoading = false;
      });
      
      _animationController.forward();
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
      final forecast = await _weatherService.getWeatherForecast(cityName);
      final isFavorite = await _favoritesService.isFavorite(weather.cityName);
      
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isFavorite = isFavorite;
        _isLoading = false;
      });
      
      _animationController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get weather: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_weather == null) return;

    if (_isFavorite) {
      await _favoritesService.removeFavorite(_weather!.cityName);
      setState(() {
        _isFavorite = false;
      });
    } else {
      await _favoritesService.addFavorite(_weather!.cityName);
      setState(() {
        _isFavorite = true;
      });
    }
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchSheet(onCitySelected: _searchWeather),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? _buildLoadingScreen()
          : _errorMessage.isNotEmpty
              ? _buildErrorScreen()
              : _buildWeatherScreen(),
      floatingActionButton: _weather != null ? _buildFloatingActions() : null,
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading Weather...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _getLocationWeather,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherScreen() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _fadeAnimation.value) * 20),
            child: child,
          ),
        );
      },
      child: CustomScrollView(
        slivers: [
          // Header Section
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: _weather != null
                ? WeatherHeader(
                    weather: _weather!,
                    isFavorite: _isFavorite,
                    onFavoriteToggle: _toggleFavorite,
                  )
                : null,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: widget.onThemeToggle,
              ),
            ],
          ),

          // Weather Details
          if (_weather != null)
            SliverToBoxAdapter(
              child: WeatherDetails(weather: _weather!),
            ),

          // Hourly Forecast
          if (_forecast != null)
            SliverToBoxAdapter(
              child: HourlyForecast(forecast: _forecast!),
            ),

          // Daily Forecast
          if (_forecast != null)
            SliverToBoxAdapter(
              child: DailyForecastWidget(forecast: _forecast!), // Updated widget name
           ),  
          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'search_fab',
            onPressed: _showSearchSheet,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.search),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'location_fab',
            onPressed: _getLocationWeather,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'favorites_fab',
            onPressed: () async {
              final selectedCity = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
              if (selectedCity != null) {
                _searchWeather(selectedCity);
              }
            },
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }
}