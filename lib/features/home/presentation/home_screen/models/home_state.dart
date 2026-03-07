import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(<ScanRecord>[]) List<ScanRecord> recentScans,
    @Default(0) int totalScans,
    @Default('--') String averageGrade,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    @Default('') String errorMessage,
  }) = _HomeState;
}
