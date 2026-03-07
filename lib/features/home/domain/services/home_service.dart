import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/infrastructure/logging/logger.dart';
import 'package:kubo_dex/features/home/data/api/home_api.dart';
import 'package:kubo_dex/features/home/domain/entities/sample_entity.dart';
import 'package:kubo_dex/features/home/domain/mapper/sample_mapper.dart';

abstract interface class HomeService {
  Future<List<SampleEntity>> getItems();
  Future<SampleEntity> getItemById(String id);
}

@LazySingleton(as: HomeService)
class HomeServiceImpl implements HomeService {
  final HomeApi _homeApi;
  final SampleMapper _sampleMapper;
  final Logger _logger;

  const HomeServiceImpl(this._homeApi, this._sampleMapper, this._logger);

  @override
  Future<List<SampleEntity>> getItems() async {
    try {
      final response = await _homeApi.getItems();
      return _sampleMapper.toEntityList(response);
    } catch (e, st) {
      _logger.log(LogLevel.error, 'Failed to get items', e, st);
      rethrow;
    }
  }

  @override
  Future<SampleEntity> getItemById(String id) async {
    try {
      final response = await _homeApi.getItemById(id);
      return _sampleMapper.toEntity(response);
    } catch (e, st) {
      _logger.log(LogLevel.error, 'Failed to get item by id: $id', e, st);
      rethrow;
    }
  }
}
