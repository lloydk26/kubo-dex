import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/presentation/cubit/cubit_base.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';
import 'package:kubo_dex/features/pre_scan/presentation/pre_scan_screen/models/pre_scan_state.dart';

@injectable
class PreScanCubit extends CubitBase<PreScanState> {
  PreScanCubit() : super(const PreScanState());

  void selectAuto() {
    emit(state.copyWith(isAuto: true, clearCrop: true));
  }

  void selectCrop(CropType crop) {
    final alreadySelected = !state.isAuto && state.selectedCrop == crop;
    if (alreadySelected) {
      // Tapping the active crop deselects it → revert to Auto
      emit(state.copyWith(isAuto: true, clearCrop: true));
    } else {
      emit(state.copyWith(selectedCrop: crop, isAuto: false));
    }
  }

  void setCaptureMode(CaptureMode mode) {
    emit(state.copyWith(captureMode: mode));
  }

  void dismissTip() {
    emit(state.copyWith(showTip: false));
  }
}
