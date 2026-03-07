import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/infrastructure/storage/shared_prefs_service.dart';

const _kScanCount = 'scan_count';

abstract interface class ScanStatsRepository {
  int getScanCount();
  Future<void> incrementScanCount();
}

@LazySingleton(as: ScanStatsRepository)
class ScanStatsRepositoryImpl implements ScanStatsRepository {
  final SharedPrefsService _prefs;

  const ScanStatsRepositoryImpl(this._prefs);

  @override
  int getScanCount() => _prefs.getInt(_kScanCount) ?? 0;

  @override
  Future<void> incrementScanCount() async {
    final current = _prefs.getInt(_kScanCount) ?? 0;
    await _prefs.setInt(_kScanCount, current + 1);
  }
}
