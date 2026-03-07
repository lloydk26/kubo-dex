import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/presentation/cubit/cubit_base.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';
import 'package:kubo_dex/features/pre_scan/presentation/pre_scan_screen/models/pre_scan_state.dart';

@injectable
class PreScanCubit extends CubitBase<PreScanState> {
  PreScanCubit() : super(const PreScanState());

  void selectCrop(CropType crop) {
    final alreadySelected = state.selectedCrop == crop;
    if (alreadySelected) {
      emit(state.copyWith(clearCrop: true));
    } else {
      emit(state.copyWith(selectedCrop: crop));
    }
  }

  void setCaptureMode(CaptureMode mode) {
    emit(state.copyWith(captureMode: mode));
  }

  void dismissTip() {
    emit(state.copyWith(showTip: false));
  }
}
