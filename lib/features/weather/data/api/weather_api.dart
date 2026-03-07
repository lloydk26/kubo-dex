import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/data/api/dio_provider.dart';
import 'package:kubo_dex/features/weather/data/contracts/weather_forecast_contract.dart';
import 'package:retrofit/retrofit.dart';

part 'weather_api.g.dart';

@lazySingleton
@RestApi()
abstract interface class WeatherApi {
  @factoryMethod
  factory WeatherApi(DioProvider dioProvider, @weatherApiUrl String baseUrl) =>
      _WeatherApi(dioProvider.create<WeatherApi>(), baseUrl: baseUrl);

  @GET('/weather')
  Future<ForecastResponseContract> getForecast({
    @Query('lat') required double lat,
    @Query('lon') required double lon,
  });
}
