import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/infrastructure/logging/logger.dart';
import 'package:kubo_dex/features/weather/data/api/weather_api.dart';
import 'package:kubo_dex/features/weather/domain/entities/weather_forecast.dart';
import 'package:kubo_dex/features/weather/domain/mapper/weather_mapper.dart';

abstract interface class WeatherService {
  Future<List<DailyForecast>> getForecast({
    required double lat,
    required double lon,
  });
}

@LazySingleton(as: WeatherService)
class WeatherServiceImpl implements WeatherService {
  final WeatherApi _weatherApi;
  final WeatherMapper _weatherMapper;
  final Logger _logger;

  const WeatherServiceImpl(this._weatherApi, this._weatherMapper, this._logger);

  @override
  Future<List<DailyForecast>> getForecast({
    required double lat,
    required double lon,
  }) async {
    _logger.log(
      LogLevel.info,
      '[WeatherService] getForecast → GET /forecast\n'
      '  lat: $lat  lon: $lon',
    );
    try {
      final response = await _weatherApi.getForecast(lat: lat, lon: lon);
      _logger.log(
        LogLevel.info,
        '[WeatherService] ✓ getForecast — ${response.data.length} days',
      );
      return _weatherMapper.toEntityList(response.data);
    } catch (e, st) {
      _logger.log(LogLevel.error, '[WeatherService] getForecast failed', e, st);
      rethrow;
    }
  }
}
