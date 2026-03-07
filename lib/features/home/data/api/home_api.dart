import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/data/api/dio_provider.dart';
import 'package:kubo_dex/features/home/data/contracts/sample_response_contract.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api.g.dart';

@lazySingleton
@RestApi()
abstract interface class HomeApi {
  @factoryMethod
  factory HomeApi(DioProvider dioProvider, @appServerUrl String baseUrl) =>
      _HomeApi(dioProvider.create<HomeApi>(), baseUrl: baseUrl);

  @GET('/items')
  Future<List<SampleResponseContract>> getItems();

  @GET('/items/{id}')
  Future<SampleResponseContract> getItemById(@Path('id') String id);
}
