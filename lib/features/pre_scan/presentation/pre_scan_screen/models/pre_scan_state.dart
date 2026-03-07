import 'package:equatable/equatable.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';

enum CaptureMode { photo, video }

class PreScanState extends Equatable {
  final CropType? selectedCrop;
  final bool isAuto;
  final CaptureMode captureMode;
  final bool showTip;

  const PreScanState({
    this.selectedCrop,
    this.isAuto = true,
    this.captureMode = CaptureMode.photo,
    this.showTip = true,
  });

  bool get canProceed => isAuto || selectedCrop != null;

  PreScanState copyWith({
    CropType? selectedCrop,
    bool clearCrop = false,
    bool? isAuto,
    CaptureMode? captureMode,
    bool? showTip,
  }) {
    return PreScanState(
      selectedCrop: clearCrop ? null : selectedCrop ?? this.selectedCrop,
      isAuto: isAuto ?? this.isAuto,
      captureMode: captureMode ?? this.captureMode,
      showTip: showTip ?? this.showTip,
    );
  }

  @override
  List<Object?> get props => [selectedCrop, isAuto, captureMode, showTip];
}
