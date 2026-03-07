import 'package:equatable/equatable.dart';

enum HealthStatus { healthy, needsImproving, critical }

// ── Nested response models ────────────────────────────────────────────────────

class HealthBreakdown extends Equatable {
  final int foliage;
  final int stem;
  final int coloration;

  const HealthBreakdown({
    required this.foliage,
    required this.stem,
    required this.coloration,
  });

  factory HealthBreakdown.fromJson(Map<String, dynamic> json) =>
      HealthBreakdown(
        foliage: (json['foliage'] as num).toInt(),
        stem: (json['stem'] as num).toInt(),
        coloration: (json['coloration'] as num).toInt(),
      );

  @override
  List<Object?> get props => [foliage, stem, coloration];
}

class HealthDetail extends Equatable {
  final String status;
  final bool isHealthy;
  final String condition;
  final double diseaseConfidencePct;
  final double cropConfidencePct;
  final HealthBreakdown breakdown;

  const HealthDetail({
    required this.status,
    required this.isHealthy,
    required this.condition,
    required this.diseaseConfidencePct,
    required this.cropConfidencePct,
    required this.breakdown,
  });

  factory HealthDetail.fromJson(Map<String, dynamic> json) => HealthDetail(
        status: json['status'] as String,
        isHealthy: json['is_healthy'] as bool,
        condition: json['condition'] as String,
        diseaseConfidencePct:
            (json['disease_confidence_pct'] as num).toDouble(),
        cropConfidencePct: (json['crop_confidence_pct'] as num).toDouble(),
        breakdown:
            HealthBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props => [
        status,
        isHealthy,
        condition,
        diseaseConfidencePct,
        cropConfidencePct,
        breakdown,
      ];
}

class HealthData extends Equatable {
  final int score;
  final HealthDetail data;

  const HealthData({required this.score, required this.data});

  factory HealthData.fromJson(Map<String, dynamic> json) => HealthData(
        score: (json['score'] as num).toInt(),
        data: HealthDetail.fromJson(json['data'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props => [score, data];
}

// ── Root response model ───────────────────────────────────────────────────────

class DiagnosisResult extends Equatable {
  final double confidence;
  final String image;
  final String name;
  final List<String> type;
  final String description;
  final HealthData health;
  final List<String> recommendation;

  const DiagnosisResult({
    required this.confidence,
    required this.image,
    required this.name,
    required this.type,
    required this.description,
    required this.health,
    required this.recommendation,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) => DiagnosisResult(
        confidence: (json['confidence'] as num).toDouble(),
        image: json['image'] as String,
        name: json['name'] as String,
        type: List<String>.from(json['type'] as List),
        description: json['description'] as String,
        health: HealthData.fromJson(json['health'] as Map<String, dynamic>),
        recommendation: List<String>.from(json['recommendation'] as List),
      );

  // ── Derived UI helpers ──────────────────────────────────────────────────────

  HealthStatus get healthStatus {
    if (health.data.isHealthy) return HealthStatus.healthy;
    final s = health.data.status.toLowerCase();
    if (s == 'poor' || s == 'critical' || s == 'severe') {
      return HealthStatus.critical;
    }
    return HealthStatus.needsImproving;
  }

  @override
  List<Object?> get props => [confidence, image, name, type, health, recommendation];
}
