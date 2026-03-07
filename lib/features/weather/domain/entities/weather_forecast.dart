import 'package:equatable/equatable.dart';

class DailyForecast extends Equatable {
  final DateTime day;
  final String weather;
  final String description;
  final double temperature;
  final double precipitation;

  const DailyForecast({
    required this.day,
    required this.weather,
    required this.description,
    required this.temperature,
    required this.precipitation,
  });

  @override
  List<Object?> get props => [day, weather, description, temperature, precipitation];
}
