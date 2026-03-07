import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/constants/app_config.dart';
import 'package:kubo_dex/core/data/api/dio_provider.dart';
import 'package:kubo_dex/core/infrastructure/logging/logger.dart';
import 'package:kubo_dex/features/diagnosis/domain/entities/diagnosis_result.dart';

@lazySingleton
class ScannerApiService {
  late final Dio _dio;
  final Logger _logger;

  ScannerApiService(DioProvider dioProvider, this._logger) {
    _dio = dioProvider.create<ScannerApiService>();
  }

  Future<DiagnosisResult> analyzeCrop(String imagePath) async {
    const endpoint = AppConfig.analyzeCropEndpoint;

    // ── Pre-call log ──────────────────────────────────────────────────────────
    _logger.log(
      LogLevel.info,
      '[ScannerApiService] POST $endpoint\n'
      '  body: multipart/form-data\n'
      '  field: image = $imagePath',
    );

    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: 'crop.jpg',
        ),
      });

      final response = await _dio.post(endpoint, data: formData);
      final statusCode = response.statusCode ?? 0;

      // ── 2xx success ───────────────────────────────────────────────────────
      _logger.log(
        LogLevel.info,
        '[ScannerApiService] ✓ $statusCode ${response.statusMessage ?? 'OK'}\n'
        '  confidence : ${response.data?['confidence']}\n'
        '  name       : ${response.data?['name']}\n'
        '  health     : ${response.data?['health']}',
      );

      return DiagnosisResult.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e, st) {
      final statusCode = e.response?.statusCode;

      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        // ── 4xx client error ────────────────────────────────────────────────
        _logger.log(
          LogLevel.warning,
          '[ScannerApiService] ✗ $statusCode ${e.response?.statusMessage ?? ''}\n'
          '  type    : ${e.type.name}\n'
          '  message : ${e.message}\n'
          '  body    : ${e.response?.data}',
          e,
          st,
        );
        throw Exception(
          'Request error ($statusCode): ${e.response?.data?['message'] ?? e.message}',
        );
      } else if (statusCode != null && statusCode >= 500) {
        // ── 5xx server error ────────────────────────────────────────────────
        _logger.log(
          LogLevel.error,
          '[ScannerApiService] ✗ $statusCode ${e.response?.statusMessage ?? ''}\n'
          '  type    : ${e.type.name}\n'
          '  message : ${e.message}\n'
          '  body    : ${e.response?.data}',
          e,
          st,
        );
        throw Exception(
          'Server error ($statusCode). Subukan muli mamaya.',
        );
      } else {
        // ── Network / timeout / parse error ────────────────────────────────
        _logger.log(
          LogLevel.error,
          '[ScannerApiService] ✗ Network error\n'
          '  type    : ${e.type.name}\n'
          '  message : ${e.message}',
          e,
          st,
        );
        throw Exception(
          'Hindi makakonekta sa server. Tingnan ang internet connection.',
        );
      }
    } catch (e, st) {
      // ── Unexpected / parse errors ─────────────────────────────────────────
      _logger.log(
        LogLevel.error,
        '[ScannerApiService] ✗ Unexpected error: $e',
        e,
        st,
      );
      rethrow;
    }
  }
}
