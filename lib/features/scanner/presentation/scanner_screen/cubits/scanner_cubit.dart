import 'dart:async';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/presentation/cubit/cubit_base.dart';
import 'package:kubo_dex/features/scanner/domain/services/scanner_service.dart';
import 'package:kubo_dex/features/scanner/presentation/scanner_screen/models/scanner_state.dart';

@injectable
class ScannerCubit extends CubitBase<ScannerState> {
  final ScannerService _scannerService;
  Timer? _nudgeTimer;

  ScannerCubit(this._scannerService) : super(const ScannerState());

  void onCameraReady() {
    emit(state.copyWith(status: ScannerStatus.ready));
    _startNudgeCycle();
  }

  void onCameraError(String message) {
    emit(state.copyWith(status: ScannerStatus.initializing, error: message));
  }

  Future<void> capturePhoto(String imagePath, {String? plant}) async {
    if (!state.isReady) return;
    _nudgeTimer?.cancel();
    _nudgeTimer = null;
    emit(state.copyWith(status: ScannerStatus.processing));

    try {
      final compressedPath = await _compressImage(imagePath);
      final result =
          await _scannerService.analyzeCrop(compressedPath, plant: plant);
      if (!isClosed) {
        emit(state.copyWith(status: ScannerStatus.done, result: result));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          status: ScannerStatus.error,
          error: 'Hindi ma-analyze ang larawan. Subukan muli.',
        ));
      }
    }
  }

  /// Compresses [imagePath] to JPEG at 80 % quality, max 1024 px on the long
  /// edge. Falls back to the original path if compression fails.
  Future<String> _compressImage(String imagePath) async {
    final original = File(imagePath);
    final targetPath =
        '${original.parent.path}/compressed_${original.uri.pathSegments.last}';

    final result = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      targetPath,
      quality: 80,
      minWidth: 1024,
      minHeight: 1024,
      format: CompressFormat.jpeg,
    );

    return result?.path ?? imagePath;
  }

  void retryCapture() {
    emit(state.copyWith(status: ScannerStatus.ready, error: null));
    _startNudgeCycle();
  }

  void _startNudgeCycle() {
    _nudgeTimer?.cancel();
    _nudgeTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!isClosed && state.isReady) {
        emit(state.copyWith(nudgeIndex: state.nudgeIndex + 1));
      }
    });
  }

  @override
  Future<void> close() {
    _nudgeTimer?.cancel();
    return super.close();
  }
}
