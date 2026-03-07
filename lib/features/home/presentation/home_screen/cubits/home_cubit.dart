import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/data/repositories/scan_history_repository.dart';
import 'package:kubo_dex/core/data/repositories/scan_stats_repository.dart';
import 'package:kubo_dex/core/infrastructure/logging/logger.dart';
import 'package:kubo_dex/core/presentation/cubit/cubit_base.dart';
import 'package:kubo_dex/features/home/presentation/home_screen/models/home_state.dart';

@injectable
class HomeCubit extends CubitBase<HomeState> {
  final Logger _logger;
  final ScanStatsRepository _scanStats;
  final ScanHistoryRepository _scanHistory;

  HomeCubit(this._logger, this._scanStats, this._scanHistory)
      : super(const HomeState());

  @override
  Future<void> onInitialize([Object? parameter]) async {
    await loadDashboard();
  }

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, hasError: false, errorMessage: ''));

    try {
      emit(
        state.copyWith(
          recentScans: _scanHistory.getRecentScans(),
          totalScans: _scanStats.getScanCount(),
          averageGrade: _scanHistory.getAverageGrade(),
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
