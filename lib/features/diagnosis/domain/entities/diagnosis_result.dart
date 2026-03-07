import 'package:equatable/equatable.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';

enum HealthStatus { healthy, needsImproving, critical }

class RecommendationItem extends Equatable {
  final String action;
  final String timeline;

  const RecommendationItem({required this.action, required this.timeline});

  @override
  List<Object?> get props => [action, timeline];
}

class DiagnosisResult extends Equatable {
  final String cropName;
  final String cropCategory;
  final CropType cropType;
  final HealthStatus healthStatus;
  final int confidencePercent;
  final String summary;
  final String flavorText;
  final List<RecommendationItem> recommendations;
  final int harvestDays;
  final DateTime scannedAt;

  const DiagnosisResult({
    required this.cropName,
    required this.cropCategory,
    required this.cropType,
    required this.healthStatus,
    required this.confidencePercent,
    required this.summary,
    required this.flavorText,
    required this.recommendations,
    required this.harvestDays,
    required this.scannedAt,
  });

  static DiagnosisResult mock() => DiagnosisResult(
        cropName: 'Pechay',
        cropCategory: 'Leafy',
        cropType: CropType.pechay,
        healthStatus: HealthStatus.needsImproving,
        confidencePercent: 87,
        summary: 'Your pechay shows signs of nitrogen deficiency.',
        flavorText:
            'A fast-growing leafy crop that thrives in cool, well-irrigated soil.',
        recommendations: const [
          RecommendationItem(
            action: 'Apply nitrogen-rich fertilizer',
            timeline: 'Every 3 days for 2 weeks',
          ),
          RecommendationItem(
            action: 'Improve soil drainage and aeration',
            timeline: 'Once before next watering cycle',
          ),
          RecommendationItem(
            action: 'Reduce direct midday sun exposure',
            timeline: 'Ongoing until recovery signs appear',
          ),
        ],
        harvestDays: 50,
        scannedAt: DateTime.now(),
      );

  @override
  List<Object?> get props => [
        cropName,
        cropType,
        healthStatus,
        confidencePercent,
        summary,
        harvestDays,
        scannedAt,
      ];
}
