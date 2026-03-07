import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/data/api/dio_provider.dart';
import 'package:kubo_dex/features/scanner/data/contracts/analyze_crop_response_contract.dart';
import 'package:retrofit/retrofit.dart';

part 'scanner_api.g.dart';

@lazySingleton
@RestApi()
abstract interface class ScannerApi {
  @factoryMethod
  factory ScannerApi(DioProvider dioProvider, @appServerUrl String baseUrl) =>
      _ScannerApi(dioProvider.create<ScannerApi>(), baseUrl: baseUrl);

  @MultiPart()
  @POST('/analyze')
  Future<AnalyzeCropResponseContract> analyzeCrop(
    @Part(name: 'image') File image, {
    @Part(name: 'plant') String? plant,
  });
}
