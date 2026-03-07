import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kubo_dex/features/home/domain/entities/sample_entity.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(<SampleEntity>[]) List<SampleEntity> items,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    @Default('') String errorMessage,
  }) = _HomeState;
}
