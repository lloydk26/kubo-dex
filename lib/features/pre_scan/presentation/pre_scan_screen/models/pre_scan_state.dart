import 'package:equatable/equatable.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';

enum CaptureMode { photo, video }

class PreScanState extends Equatable {
  final CropType? selectedCrop;
  final CaptureMode captureMode;
  final bool showTip;

  const PreScanState({
    this.selectedCrop,
    this.captureMode = CaptureMode.photo,
    this.showTip = true,
  });

  bool get canProceed => selectedCrop != null;

  PreScanState copyWith({
    CropType? selectedCrop,
    bool clearCrop = false,
    CaptureMode? captureMode,
    bool? showTip,
  }) {
    return PreScanState(
      selectedCrop: clearCrop ? null : selectedCrop ?? this.selectedCrop,
      captureMode: captureMode ?? this.captureMode,
      showTip: showTip ?? this.showTip,
    );
  }

  @override
  List<Object?> get props => [selectedCrop, captureMode, showTip];
}
