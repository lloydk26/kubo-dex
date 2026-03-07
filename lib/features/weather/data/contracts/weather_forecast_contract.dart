import 'package:json_annotation/json_annotation.dart';
import 'package:kubo_dex/core/data/json/json_serializable_object.dart';

part 'weather_forecast_contract.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DailyForecastContract extends JsonSerializableObject {
  final String date;
  final String weather;
  final double temperature;
  final double precipitation;
  final String description;

  const DailyForecastContract({
    required this.date,
    required this.weather,
    required this.temperature,
    required this.precipitation,
    required this.description,
  });

  factory DailyForecastContract.fromJson(Map<String, dynamic> json) =>
      _$DailyForecastContractFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DailyForecastContractToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ForecastResponseContract extends JsonSerializableObject {
  final List<DailyForecastContract> data;

  const ForecastResponseContract({required this.data});

  factory ForecastResponseContract.fromJson(Map<String, dynamic> json) =>
      _$ForecastResponseContractFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ForecastResponseContractToJson(this);
}
