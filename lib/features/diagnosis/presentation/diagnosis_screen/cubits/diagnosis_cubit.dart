import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/presentation/cubit/cubit_base.dart';
import 'package:kubo_dex/features/diagnosis/presentation/diagnosis_screen/models/diagnosis_state.dart';

@injectable
class DiagnosisCubit extends CubitBase<DiagnosisState> {
  DiagnosisCubit() : super(const DiagnosisState());

  void submitFeedback(bool helpful) {
    emit(state.copyWith(feedbackHelpful: helpful));
  }
}
