import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:kubo_dex/features/diagnosis/domain/entities/diagnosis_result.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';

abstract interface class ScanHistoryRepository {
  Future<void> saveScan(DiagnosisResult result);
  List<ScanRecord> getRecentScans({int limit = 10});
  String getAverageGrade();
}

@LazySingleton(as: ScanHistoryRepository)
class ScanHistoryRepositoryImpl implements ScanHistoryRepository {
  final Box _box;

  ScanHistoryRepositoryImpl(@Named('scanHistoryBox') this._box);

  static const _cropKeywords = <String, CropType>{
    'pechay': CropType.pechay,
    'tomato': CropType.tomato,
    'eggplant': CropType.eggplant,
    'rice': CropType.rice,
    'mais': CropType.mais,
    'corn': CropType.mais,
  };

  CropType _resolveCropType(String name) {
    final lower = name.toLowerCase();
    for (final entry in _cropKeywords.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return CropType.other;
  }

  CropGrade _gradeFromScore(int score) {
    if (score >= 70) return CropGrade.a;
    if (score >= 40) return CropGrade.b;
    return CropGrade.c;
  }

  String _gradeStringFromScore(double meanScore) {
    if (meanScore >= 70) return 'A';
    if (meanScore >= 40) return 'B';
    return 'C';
  }

  @override
  Future<void> saveScan(DiagnosisResult result) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final cropType = _resolveCropType(result.name);

    await _box.add({
      'id': id,
      'cropName': result.name,
      'cropType': cropType.name,
      'healthScore': result.health.score,
      'confidence': result.confidence,
      'scannedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  List<ScanRecord> getRecentScans({int limit = 10}) {
    final entries = _box.values
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    entries.sort(
      (a, b) => (b['scannedAt'] as int).compareTo(a['scannedAt'] as int),
    );

    return entries.take(limit).map((e) {
      final cropTypeStr = (e['cropType'] as String?) ?? 'other';
      final cropType = CropType.values.firstWhere(
        (t) => t.name == cropTypeStr,
        orElse: () => CropType.other,
      );
      final healthScore = (e['healthScore'] as num?)?.toInt() ?? 0;

      return ScanRecord(
        id: e['id'] as String,
        cropName: e['cropName'] as String,
        cropType: cropType,
        grade: _gradeFromScore(healthScore),
        scannedAt: DateTime.fromMillisecondsSinceEpoch(e['scannedAt'] as int),
      );
    }).toList();
  }

  @override
  String getAverageGrade() {
    final scores = _box.values
        .whereType<Map>()
        .map((e) => (e['healthScore'] as num?)?.toDouble() ?? 0.0)
        .toList();

    if (scores.isEmpty) return '--';

    final mean = scores.reduce((a, b) => a + b) / scores.length;
    return _gradeStringFromScore(mean);
  }
}
