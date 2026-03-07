import 'package:equatable/equatable.dart';

enum HealthStatus { healthy, needsImproving, critical }

// ── Domain value objects ──────────────────────────────────────────────────────

class HealthBreakdown extends Equatable {
  final int foliage;
  final int stem;
  final int coloration;

  const HealthBreakdown({
    required this.foliage,
    required this.stem,
    required this.coloration,
  });

  @override
  List<Object?> get props => [foliage, stem, coloration];
}

class HealthDetail extends Equatable {
  final String status;
  final bool isHealthy;
  final String? condition;
  final double? diseaseConfidencePct;
  final double cropConfidencePct;
  final HealthBreakdown? breakdown;

  const HealthDetail({
    required this.status,
    required this.isHealthy,
    this.condition,
    this.diseaseConfidencePct,
    required this.cropConfidencePct,
    this.breakdown,
  });

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

  @override
  List<Object?> get props => [score, data];
}

// ── Root entity ───────────────────────────────────────────────────────────────

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

  // ── Derived helpers ─────────────────────────────────────────────────────────

  HealthStatus get healthStatus {
    if (health.data.isHealthy) return HealthStatus.healthy;
    final s = health.data.status.toLowerCase();
    if (s == 'poor' || s == 'critical' || s == 'severe') {
      return HealthStatus.critical;
    }
    return HealthStatus.needsImproving;
  }

  @override
  List<Object?> get props => [
        confidence,
        image,
        name,
        type,
        health,
        recommendation,
      ];
}
