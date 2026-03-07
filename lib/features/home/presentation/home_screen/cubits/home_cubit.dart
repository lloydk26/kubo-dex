import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/infrastructure/logging/logger.dart';
import 'package:kubo_dex/core/presentation/cubit/cubit_base.dart';
import 'package:kubo_dex/features/home/domain/entities/sample_entity.dart';
import 'package:kubo_dex/features/home/domain/services/home_service.dart';
import 'package:kubo_dex/features/home/presentation/home_screen/models/home_state.dart';

@injectable
class HomeCubit extends CubitBase<HomeState> {
  final HomeService _homeService;
  final Logger _logger;

  HomeCubit(this._homeService, this._logger) : super(const HomeState());

  @override
  Future<void> onInitialize([Object? parameter]) async {
    await loadItems();
  }

  Future<void> loadItems() async {
    emit(state.copyWith(isLoading: true, hasError: false, errorMessage: ''));

    try {
      // final items = await _homeService.getItems();
      final items = [
        // Assuming SampleEntity (modify fields as needed)
        SampleEntity(id: '1', title: 'Item 1', description: 'Description 1'),
        SampleEntity(id: '2', title: 'Item 2', description: 'Description 2'),
        SampleEntity(id: '3', title: 'Item 3', description: 'Description 3'),
      ];
      emit(state.copyWith(items: items, isLoading: false));
    } catch (e, st) {
      _logger.log(LogLevel.error, 'Failed to load items', e, st);
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
