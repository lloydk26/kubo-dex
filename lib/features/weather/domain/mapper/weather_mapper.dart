import 'package:injectable/injectable.dart';
import 'package:kubo_dex/features/weather/data/contracts/weather_forecast_contract.dart';
import 'package:kubo_dex/features/weather/domain/entities/weather_forecast.dart';

@injectable
class WeatherMapper {
  const WeatherMapper();

  DailyForecast toEntity(DailyForecastContract contract) {
    return DailyForecast(
      day: DateTime.parse(contract.date),
      weather: contract.weather,
      description: contract.description,
      temperature: contract.temperature,
      precipitation: contract.precipitation,
    );
  }

  List<DailyForecast> toEntityList(List<DailyForecastContract> contracts) =>
      contracts.map(toEntity).toList();
}
