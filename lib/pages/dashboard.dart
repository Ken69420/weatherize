// filepath: /c:/Weatherize/weatherize/lib/pages/dashboard.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _locationMessage = "Location Not Found";
  String _weatherMessage = "Weather Not Found";
  Map<String, dynamic> _weatherData = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            "Location permissions are permanently denied, we cannot request permissions.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _getAddressFromLatLng(position.latitude, position.longitude);
    _fetchWeather(position.latitude, position.longitude);
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        _locationMessage = "${place.locality}, ${place.country}";
      });

      //Update firestore with location
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'location': _locationMessage,
        });
      }
    } catch (e) {
      setState(() {
        _locationMessage = "Location not found";
      });
    }
  }

  Future<void> _fetchWeather(double latitude, double longitude) async {
    const apiKey = '08c10920bb65bc9740748098e4b09408';
    final url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _weatherData = data;
        _weatherMessage =
            "Temperature: ${data['current']['temp'].round()}°C\nWeather: ${data['current']['weather'][0]['description']}";
      });
    } else {
      setState(() {
        _weatherMessage = "Weather data not found";
      });
    }
  }

  IconData _getWeatherIcon(String description) {
    switch (description) {
      case 'clear sky':
        return Icons.wb_sunny;
      case 'few clouds':
        return Icons.cloud;
      case 'scattered clouds':
        return Icons.cloud_queue;
      case 'broken clouds':
        return Icons.cloud_off;
      case 'shower rain':
        return Icons.grain;
      case 'rain':
        return Icons.beach_access;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
        return Icons.blur_on;
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ));
                }),
          ]),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                      0.8), // White background with reduced opacity
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      _buildCurrentWeather(),
                      const SizedBox(height: 40),
                      _buildHourlyForecast(),
                      const SizedBox(height: 60),
                      _buildDailyForecast(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    if (_weatherData.isEmpty) {
      return Text(_weatherMessage);
    }

    return Column(
      children: [
        Text(
          _locationMessage,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${_weatherData['current']['temp'].round()}°C',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getWeatherIcon(
                _weatherData['current']['weather'][0]['description'])),
            const SizedBox(width: 10),
            Text(_weatherData['current']['weather'][0]['description']),
          ],
        ),
        Text(
            'High: ${_weatherData['daily'][0]['temp']['max'].round()}°C, Low: ${_weatherData['daily'][0]['temp']['min'].round()}°C'),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    if (_weatherData.isEmpty) {
      return const Text('Hourly forecast not available');
    }

    return Column(
      children: [
        const Text('Hourly Forecast',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(24, (index) {
              final hourData = _weatherData['hourly'][index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(
                        '${DateTime.fromMillisecondsSinceEpoch(hourData['dt'] * 1000).hour}:00'),
                    Text('${hourData['temp'].round()}°C'),
                    Icon(
                        _getWeatherIcon(hourData['weather'][0]['description'])),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  Widget _buildDailyForecast() {
    if (_weatherData.isEmpty) {
      return const Text('Daily forecast not available');
    }

    return Column(
      children: List.generate(7, (index) {
        final dayData = _weatherData['daily'][index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _getDayOfWeek(
                    DateTime.fromMillisecondsSinceEpoch(dayData['dt'] * 1000)
                        .weekday),
              ),
              const SizedBox(width: 10),
              Icon(_getWeatherIcon(dayData['weather'][0]['description'])),
              const SizedBox(width: 10),
              Text('Avg Temp: ${dayData['temp']['day'].round()}°C'),
            ],
          ),
        );
      }),
    );
  }
}
