import 'package:json_annotation/json_annotation.dart';
import 'package:kubo_dex/core/data/json/json_serializable_object.dart';

part 'analyze_crop_response_contract.g.dart';

// ── Breakdown ─────────────────────────────────────────────────────────────────

@JsonSerializable(fieldRename: FieldRename.snake)
class HealthBreakdownContract extends JsonSerializableObject {
  final int foliage;
  final int stem;
  final int coloration;

  const HealthBreakdownContract({
    required this.foliage,
    required this.stem,
    required this.coloration,
  });

  factory HealthBreakdownContract.fromJson(Map<String, dynamic> json) =>
      _$HealthBreakdownContractFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HealthBreakdownContractToJson(this);
}

// ── Health detail (health.data) ───────────────────────────────────────────────

@JsonSerializable(fieldRename: FieldRename.snake)
class HealthDetailContract extends JsonSerializableObject {
  final String status;
  final bool isHealthy;
  final String condition;
  final double diseaseConfidencePct;
  final double cropConfidencePct;
  final HealthBreakdownContract breakdown;

  const HealthDetailContract({
    required this.status,
    required this.isHealthy,
    required this.condition,
    required this.diseaseConfidencePct,
    required this.cropConfidencePct,
    required this.breakdown,
  });

  factory HealthDetailContract.fromJson(Map<String, dynamic> json) =>
      _$HealthDetailContractFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HealthDetailContractToJson(this);
}

// ── Health wrapper (health) ───────────────────────────────────────────────────

@JsonSerializable(fieldRename: FieldRename.snake)
class HealthDataContract extends JsonSerializableObject {
  final int score;
  final HealthDetailContract data;

  const HealthDataContract({
    required this.score,
    required this.data,
  });

  factory HealthDataContract.fromJson(Map<String, dynamic> json) =>
      _$HealthDataContractFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HealthDataContractToJson(this);
}

// ── Root response ─────────────────────────────────────────────────────────────

@JsonSerializable(fieldRename: FieldRename.snake)
class AnalyzeCropResponseContract extends JsonSerializableObject {
  final double confidence;
  final String image;
  final String name;
  final List<String> type;
  final String description;
  final HealthDataContract health;
  final List<String> recommendation;

  const AnalyzeCropResponseContract({
    required this.confidence,
    required this.image,
    required this.name,
    required this.type,
    required this.description,
    required this.health,
    required this.recommendation,
  });

  factory AnalyzeCropResponseContract.fromJson(Map<String, dynamic> json) =>
      _$AnalyzeCropResponseContractFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AnalyzeCropResponseContractToJson(this);
}
