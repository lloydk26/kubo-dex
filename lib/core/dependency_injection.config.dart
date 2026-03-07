// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:kubo_dex/core/data/api/dio_provider.dart' as _i917;
import 'package:kubo_dex/core/infrastructure/logging/logger.dart' as _i74;
import 'package:kubo_dex/core/infrastructure/navigation/navigation_service.dart'
    as _i782;
import 'package:kubo_dex/core/infrastructure/storage/shared_prefs_service.dart'
    as _i39;
import 'package:kubo_dex/features/diagnosis/presentation/diagnosis_screen/cubits/diagnosis_cubit.dart'
    as _i144;
import 'package:kubo_dex/features/home/data/api/home_api.dart' as _i749;
import 'package:kubo_dex/features/home/domain/mapper/sample_mapper.dart'
    as _i1060;
import 'package:kubo_dex/features/home/domain/services/home_service.dart'
    as _i139;
import 'package:kubo_dex/features/home/presentation/home_screen/cubits/home_cubit.dart'
    as _i314;
import 'package:kubo_dex/features/pre_scan/presentation/pre_scan_screen/cubits/pre_scan_cubit.dart'
    as _i203;
import 'package:kubo_dex/features/scanner/data/api/scanner_api.dart' as _i849;
import 'package:kubo_dex/features/scanner/domain/mapper/diagnosis_mapper.dart'
    as _i281;
import 'package:kubo_dex/features/scanner/domain/services/scanner_service.dart'
    as _i153;
import 'package:kubo_dex/features/scanner/presentation/scanner_screen/cubits/scanner_cubit.dart'
    as _i401;
import 'package:kubo_dex/features/weather/data/api/weather_api.dart' as _i411;
import 'package:kubo_dex/features/weather/domain/mapper/weather_mapper.dart'
    as _i452;
import 'package:kubo_dex/features/weather/domain/services/weather_service.dart'
    as _i1047;
import 'package:kubo_dex/features/weather/presentation/weather_forecast_card/cubits/weather_forecast_card_cubit.dart'
    as _i374;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i1060.SampleMapper>(() => const _i1060.SampleMapper());
    gh.factory<_i203.PreScanCubit>(() => _i203.PreScanCubit());
    gh.factory<_i452.WeatherMapper>(() => const _i452.WeatherMapper());
    gh.factory<_i281.DiagnosisMapper>(() => const _i281.DiagnosisMapper());
    gh.factory<_i144.DiagnosisCubit>(() => _i144.DiagnosisCubit());
    gh.lazySingleton<_i782.NavigationService>(() => _i782.NavigationService());
    gh.lazySingleton<_i917.DioProvider>(() => _i917.DioProvider());
    gh.lazySingleton<_i74.Logger>(() => _i74.AppLogger());
    gh.lazySingleton<_i39.SharedPrefsService>(
      () => _i39.SharedPrefsServiceImpl(),
    );
    gh.factory<_i314.HomeCubit>(() => _i314.HomeCubit(gh<_i74.Logger>()));
    gh.lazySingleton<_i749.HomeApi>(
      () => _i749.HomeApi(
        gh<_i917.DioProvider>(),
        gh<String>(instanceName: 'appServerUrl'),
      ),
    );
    gh.lazySingleton<_i849.ScannerApi>(
      () => _i849.ScannerApi(
        gh<_i917.DioProvider>(),
        gh<String>(instanceName: 'appServerUrl'),
      ),
    );
    gh.lazySingleton<_i139.HomeService>(
      () => _i139.HomeServiceImpl(
        gh<_i749.HomeApi>(),
        gh<_i1060.SampleMapper>(),
        gh<_i74.Logger>(),
      ),
    );
    gh.lazySingleton<_i411.WeatherApi>(
      () => _i411.WeatherApi(
        gh<_i917.DioProvider>(),
        gh<String>(instanceName: 'weatherApiUrl'),
      ),
    );
    gh.lazySingleton<_i153.ScannerService>(
      () => _i153.ScannerServiceImpl(
        gh<_i849.ScannerApi>(),
        gh<_i281.DiagnosisMapper>(),
        gh<_i74.Logger>(),
      ),
    );
    gh.lazySingleton<_i1047.WeatherService>(
      () => _i1047.WeatherServiceImpl(
        gh<_i411.WeatherApi>(),
        gh<_i452.WeatherMapper>(),
        gh<_i74.Logger>(),
      ),
    );
    gh.factory<_i401.ScannerCubit>(
      () => _i401.ScannerCubit(gh<_i153.ScannerService>()),
    );
    gh.factory<_i374.WeatherForecastCardCubit>(
      () => _i374.WeatherForecastCardCubit(gh<_i1047.WeatherService>()),
    );
    return this;
  }
}
