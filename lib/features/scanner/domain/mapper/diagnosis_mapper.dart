import 'package:injectable/injectable.dart';
import 'package:kubo_dex/features/diagnosis/domain/entities/diagnosis_result.dart';
import 'package:kubo_dex/features/scanner/data/contracts/analyze_crop_response_contract.dart';

@injectable
class DiagnosisMapper {
  const DiagnosisMapper();

  DiagnosisResult toEntity(AnalyzeCropResponseContract contract) {
    return DiagnosisResult(
      confidence: contract.confidence,
      image: contract.image,
      name: contract.name,
      type: contract.type,
      description: contract.description,
      health: _toHealthData(contract.health),
      recommendation: contract.recommendation,
    );
  }

  HealthData _toHealthData(HealthDataContract contract) {
    return HealthData(
      score: contract.score,
      data: _toHealthDetail(contract.data),
    );
  }

  HealthDetail _toHealthDetail(HealthDetailContract contract) {
    return HealthDetail(
      status: contract.status,
      isHealthy: contract.isHealthy,
      condition: contract.condition,
      diseaseConfidencePct: contract.diseaseConfidencePct,
      cropConfidencePct: contract.cropConfidencePct,
      breakdown: _toHealthBreakdown(contract.breakdown),
    );
  }

  HealthBreakdown _toHealthBreakdown(HealthBreakdownContract contract) {
    return HealthBreakdown(
      foliage: contract.foliage,
      stem: contract.stem,
      coloration: contract.coloration,
    );
  }
}
