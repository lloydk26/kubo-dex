import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/data/repositories/scan_history_repository.dart';
import 'package:kubo_dex/core/data/repositories/scan_stats_repository.dart';
import 'package:kubo_dex/core/infrastructure/logging/logger.dart';
import 'package:kubo_dex/features/diagnosis/domain/entities/diagnosis_result.dart';
import 'package:kubo_dex/features/scanner/data/api/scanner_api.dart';
import 'package:kubo_dex/features/scanner/data/contracts/analyze_crop_request_contract.dart';
import 'package:kubo_dex/features/scanner/domain/mapper/diagnosis_mapper.dart';

abstract interface class ScannerService {
  Future<DiagnosisResult> analyzeCrop(String imagePath, {String? plant});
}

@LazySingleton(as: ScannerService)
class ScannerServiceImpl implements ScannerService {
  final ScannerApi _scannerApi;
  final DiagnosisMapper _diagnosisMapper;
  final Logger _logger;
  final ScanStatsRepository _scanStats;
  final ScanHistoryRepository _scanHistory;

  const ScannerServiceImpl(
    this._scannerApi,
    this._diagnosisMapper,
    this._logger,
    this._scanStats,
    this._scanHistory,
  );

  @override
  Future<DiagnosisResult> analyzeCrop(String imagePath, {String? plant}) async {
    _logger.log(
      LogLevel.info,
      '[ScannerService] analyzeCrop → POST /analyze\n'
      '  image: $imagePath\n'
      '  plant: ${plant ?? '(auto)'}',
    );

    try {
      final request = AnalyzeCropRequestContract(
        image: File(imagePath),
        plant: plant,
      );
      final response = await _scannerApi.analyzeCrop(
        request.image,
        plant: request.plant,
      );

      _logger.log(
        LogLevel.info,
        '[ScannerService] ✓ analyzeCrop succeeded\n'
        '  name      : ${response.name}\n'
        '  confidence: ${response.confidence}\n'
        '  status    : ${response.health.data.status}',
      );

      final result = _diagnosisMapper.toEntity(response);

      await Future.wait([
        _scanStats.incrementScanCount(),
        _scanHistory.saveScan(result),
      ]);

      return result;
    } catch (e, st) {
      _logger.log(LogLevel.error, '[ScannerService] analyzeCrop failed', e, st);
      rethrow;
    }
  }
}
