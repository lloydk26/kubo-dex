import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:flutter/foundation.dart';

abstract class CubitBase<State> extends Cubit<State> {
  CubitBase(super.initialState);

  Future<void> onInitialize([Object? parameter]) => Future.value();

  Future<void> onFirstRender([Object? parameter]) => Future.value();

  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
