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
import 'package:kubo_dex/features/home/data/api/home_api.dart' as _i749;
import 'package:kubo_dex/features/home/domain/mapper/sample_mapper.dart'
    as _i1060;
import 'package:kubo_dex/features/home/domain/services/home_service.dart'
    as _i139;
import 'package:kubo_dex/features/home/presentation/home_screen/cubits/home_cubit.dart'
    as _i314;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i1060.SampleMapper>(() => const _i1060.SampleMapper());
    gh.lazySingleton<_i782.NavigationService>(() => _i782.NavigationService());
    gh.lazySingleton<_i917.DioProvider>(() => _i917.DioProvider());
    gh.lazySingleton<_i74.Logger>(() => _i74.AppLogger());
    gh.lazySingleton<_i39.SharedPrefsService>(
      () => _i39.SharedPrefsServiceImpl(),
    );
    gh.lazySingleton<_i749.HomeApi>(
      () => _i749.HomeApi(
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
    gh.factory<_i314.HomeCubit>(
      () => _i314.HomeCubit(gh<_i139.HomeService>(), gh<_i74.Logger>()),
    );
    return this;
  }
}
