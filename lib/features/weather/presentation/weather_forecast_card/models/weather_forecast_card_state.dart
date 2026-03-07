import 'package:kubo_dex/features/weather/domain/entities/location_permission_status.dart';
import 'package:kubo_dex/features/weather/domain/entities/weather_forecast.dart';

class WeatherForecastCardState {
  final List<DailyForecast> forecasts;
  final int selectedIndex;
  final bool isLoading;
  final bool hasError;
  final LocationPermissionStatus permissionStatus;
  final double? latitude;
  final double? longitude;

  const WeatherForecastCardState({
    this.forecasts = const [],
    this.selectedIndex = 0,
    this.isLoading = false,
    this.hasError = false,
    this.permissionStatus = LocationPermissionStatus.unknown,
    this.latitude,
    this.longitude,
  });

  WeatherForecastCardState copyWith({
    List<DailyForecast>? forecasts,
    int? selectedIndex,
    bool? isLoading,
    bool? hasError,
    LocationPermissionStatus? permissionStatus,
    double? latitude,
    double? longitude,
  }) {
    return WeatherForecastCardState(
      forecasts: forecasts ?? this.forecasts,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  DailyForecast? get selected =>
      forecasts.isEmpty ? null : forecasts[selectedIndex];

  bool get isEmpty => forecasts.isEmpty;
}
