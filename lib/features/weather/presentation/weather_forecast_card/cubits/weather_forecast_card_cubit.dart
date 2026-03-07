import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/presentation/cubit/cubit_base.dart';
import 'package:kubo_dex/features/weather/domain/entities/location_permission_status.dart';
import 'package:kubo_dex/features/weather/domain/services/weather_service.dart';
import 'package:kubo_dex/features/weather/presentation/weather_forecast_card/models/weather_forecast_card_state.dart';

@injectable
class WeatherForecastCardCubit extends CubitBase<WeatherForecastCardState> {
  final WeatherService _weatherService;

  WeatherForecastCardCubit(this._weatherService)
      : super(const WeatherForecastCardState());

  @override
  Future<void> onInitialize([Object? parameter]) async {
    await _checkAndRequestLocation();
  }

  Future<void> _checkAndRequestLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      emit(state.copyWith(permissionStatus: LocationPermissionStatus.requesting));
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      emit(state.copyWith(permissionStatus: LocationPermissionStatus.denied));
      return;
    }

    emit(state.copyWith(permissionStatus: LocationPermissionStatus.granted));
    await _fetchForecast();
  }

  Future<void> _fetchForecast() async {
    emit(state.copyWith(isLoading: true, hasError: false));
    try {
      final position = await Geolocator.getCurrentPosition();
      final forecasts = await _weatherService.getForecast(
        lat: position.latitude,
        lon: position.longitude,
      );
      emit(
        state.copyWith(
          isLoading: false,
          forecasts: forecasts,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }

  /// Re-fetches forecast data. If permission was never granted it re-runs the
  /// full permission + fetch flow instead.
  Future<void> refresh() async {
    if (state.permissionStatus == LocationPermissionStatus.granted) {
      await _fetchForecast();
    } else {
      await _checkAndRequestLocation();
    }
  }

  /// Opens Android/iOS app settings so the user can grant location.
  /// The card shows [_LocationPermissionBanner] which calls this.
  Future<void> retryLocationPermission() async {
    await Geolocator.openAppSettings();
  }

  void selectDay(int index) {
    if (index < 0 || index >= state.forecasts.length) return;
    emit(state.copyWith(selectedIndex: index));
  }
}
