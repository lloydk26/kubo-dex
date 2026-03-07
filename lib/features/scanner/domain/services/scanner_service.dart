import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/infrastructure/logging/logger.dart';
import 'package:kubo_dex/features/diagnosis/domain/entities/diagnosis_result.dart';
import 'package:kubo_dex/features/scanner/data/api/scanner_api.dart';
import 'package:kubo_dex/features/scanner/domain/mapper/diagnosis_mapper.dart';

abstract interface class ScannerService {
  Future<DiagnosisResult> analyzeCrop(String imagePath);
}

@LazySingleton(as: ScannerService)
class ScannerServiceImpl implements ScannerService {
  final ScannerApi _scannerApi;
  final DiagnosisMapper _diagnosisMapper;
  final Logger _logger;

  const ScannerServiceImpl(
    this._scannerApi,
    this._diagnosisMapper,
    this._logger,
  );

  @override
  Future<DiagnosisResult> analyzeCrop(String imagePath) async {
    _logger.log(
      LogLevel.info,
      '[ScannerService] analyzeCrop → POST /analyze\n'
      '  image: $imagePath',
    );

    try {
      final response = await _scannerApi.analyzeCrop(File(imagePath));

      _logger.log(
        LogLevel.info,
        '[ScannerService] ✓ analyzeCrop succeeded\n'
        '  name      : ${response.name}\n'
        '  confidence: ${response.confidence}\n'
        '  status    : ${response.health.data.status}',
      );

      return _diagnosisMapper.toEntity(response);
    } catch (e, st) {
      _logger.log(LogLevel.error, '[ScannerService] analyzeCrop failed', e, st);
      rethrow;
    }
  }
}
