import 'dart:async';

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

  Future<void> capturePhoto(String imagePath) async {
    if (!state.isReady) return;
    _nudgeTimer?.cancel();
    _nudgeTimer = null;
    emit(state.copyWith(status: ScannerStatus.processing));

    try {
      final result = await _scannerService.analyzeCrop(imagePath);
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
