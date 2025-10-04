import 'package:flutter/material.dart';
import 'pages/weather_page.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Pro',
      theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: WeatherPage(
        key: UniqueKey(), // Add this
        onThemeToggle: _toggleTheme, 
        isDarkMode: _isDarkMode
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}