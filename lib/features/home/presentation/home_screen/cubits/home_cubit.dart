import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/infrastructure/logging/logger.dart';
import 'package:kubo_dex/core/presentation/cubit/cubit_base.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';
import 'package:kubo_dex/features/home/presentation/home_screen/models/home_state.dart';

@injectable
class HomeCubit extends CubitBase<HomeState> {
  final Logger _logger;

  HomeCubit(this._logger) : super(const HomeState());

  @override
  Future<void> onInitialize([Object? parameter]) async {
    await loadDashboard();
  }

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, hasError: false, errorMessage: ''));

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final mockScans = [
        ScanRecord(
          id: '1',
          cropName: 'Pechay',
          grade: CropGrade.a,
          scannedAt: DateTime(2024, 11, 23),
          cropType: CropType.pechay,
        ),
        ScanRecord(
          id: '2',
          cropName: 'Tomato',
          grade: CropGrade.b,
          scannedAt: DateTime(2024, 11, 21),
          cropType: CropType.tomato,
        ),
        ScanRecord(
          id: '3',
          cropName: 'Eggplant',
          grade: CropGrade.c,
          scannedAt: DateTime(2024, 11, 20),
          cropType: CropType.eggplant,
        ),
        ScanRecord(
          id: '4',
          cropName: 'Mais',
          grade: CropGrade.b,
          scannedAt: DateTime(2024, 11, 18),
          cropType: CropType.mais,
        ),
        ScanRecord(
          id: '5',
          cropName: 'Rice',
          grade: CropGrade.a,
          scannedAt: DateTime(2024, 11, 15),
          cropType: CropType.rice,
        ),
      ];

      emit(
        state.copyWith(
          recentScans: mockScans,
          totalScans: 158,
          averageGrade: 'A',
          isLoading: false,
        ),
      );
    } catch (e, st) {
      _logger.log(LogLevel.error, 'Failed to load dashboard', e, st);
      emit(
        state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
