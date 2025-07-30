import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vguard/core/app_constants.dart';
import 'package:vguard/models/weather_data.dart';
import 'package:vguard/services/weather_service.dart';

class FarmingConditionsSection extends StatefulWidget {
  const FarmingConditionsSection({super.key});

  @override
  State<FarmingConditionsSection> createState() =>
      _FarmingConditionsSectionState();
}

class _FarmingConditionsSectionState extends State<FarmingConditionsSection> {
  final WeatherService _weatherService = WeatherService();
  late Future<WeatherData> _weatherFuture;
  final double _defaultLatitude = 6.9271; //Colombo, Sri Lanka
  final double _defaultLongitude = 79.8612; // Colombo, Sri Lanka

  @override
  void initState() {
    super.initState();
    _weatherFuture = _getWeatherInitially();
  }

  // A method to handle the initial weather fetching
  Future<WeatherData> _getWeatherInitially() async {
    try {
      Position position = await _determinePosition();
      return await _weatherService.fetchWeatherData(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      print('Error during initial weather fetch: $e');
      return await _weatherService.fetchWeatherData(
        _defaultLatitude,
        _defaultLongitude,
      );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
  }

  Future<void> _refreshWeather() async {
    setState(() {
      _weatherFuture = _getWeatherInitially();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        height: screenHeight * 0.33,
        constraints: BoxConstraints(maxWidth: 1200),
        margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
        padding: EdgeInsets.all(AppSizes.paddingXLarge),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.grey100, AppColors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Farming Conditions',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.black87,
                    fontSize: 18,
                  ),
                ),
                // For the 'Optimal' tag to show dynamic status
                FutureBuilder<WeatherData>(
                  future:
                      _weatherFuture, // This is where the late variable is used
                  builder: (context, snapshot) {
                    String status = 'Loading...';
                    Color statusColor =
                        AppColors.grey100; // Changed initial color to grey
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      status = 'Loading...';
                      statusColor = AppColors.grey100;
                    } else if (snapshot.hasData) {
                      status = _weatherService.getOverallStatus(snapshot.data!);
                      if (status == 'Optimal') {
                        statusColor = AppColors.green;
                      } else if (status == 'Adverse') {
                        statusColor = AppColors.red;
                      } else {
                        statusColor = AppColors.orange; // Moderate
                      }
                    } else if (snapshot.hasError) {
                      status = 'Error';
                      statusColor = AppColors.red;
                    }
                    return Container(
                      width: 70,
                      height: 25,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingSmall + 4,
                        vertical: AppSizes.paddingSmall - 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [statusColor, statusColor.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusLarge * 0.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          status,
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingXLarge),
            FutureBuilder<WeatherData>(
              future: _weatherFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: AppColors.primaryGreen,
                      size: 30,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.red,
                          size: 30,
                        ),
                        const SizedBox(height: AppSizes.paddingSmall),
                        Text(
                          'Failed to load weather',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.black87),
                        ),
                        SizedBox(height: AppSizes.paddingSmall / 2),
                        ElevatedButton(
                          onPressed: _refreshWeather,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            foregroundColor: AppColors.white,
                          ),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ConditionItem(
                          icon: Icons.wb_sunny_outlined,
                          value: '${weather.temperature.toStringAsFixed(0)}°C',
                          label: 'Temperature',
                          iconColor: AppColors.amber,
                        ),
                      ),
                      Expanded(
                        child: ConditionItem(
                          icon: Icons.cloud_outlined,
                          value: '${weather.humidity}%',
                          label: 'Humidity',
                          iconColor: AppColors.blueGrey,
                        ),
                      ),
                      Expanded(
                        child: ConditionItem(
                          icon: Icons.trending_up,
                          value: _weatherService.getGrowthStatus(
                            weather,
                          ), // Dynamic growth
                          label: 'Growth',
                          iconColor: AppColors.green,
                        ),
                      ),
                      Expanded(
                        child: ConditionItem(
                          icon: Icons.shield_outlined,
                          value: _weatherService.getDiseaseRisk(
                            weather,
                          ), // Dynamic disease risk
                          label: 'Disease Risk',
                          iconColor: AppColors.deepOrange,
                        ),
                      ),
                    ],
                  );
                } else {
                  // This case should ideally not be reached if Future.error is used on failure
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No weather data available.'),
                        SizedBox(height: AppSizes.paddingSmall),
                        ElevatedButton(
                          onPressed: _refreshWeather,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            foregroundColor: AppColors.white,
                          ),
                          child: Text('Load Weather'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConditionItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  const ConditionItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Icon(icon, size: screenHeight * 0.04, color: iconColor),
        SizedBox(height: AppSizes.paddingSmall),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.black87,
          ),
        ),
        SizedBox(height: AppSizes.borderRadiusSmall),
        Text(label, style: TextStyle(fontSize: 14, color: AppColors.grey600)),
      ],
    );
  }
}
