import 'package:equatable/equatable.dart';

class DiagnosisState extends Equatable {
  final bool? feedbackHelpful;

  const DiagnosisState({this.feedbackHelpful});

  DiagnosisState copyWith({bool? feedbackHelpful, bool clearFeedback = false}) {
    return DiagnosisState(
      feedbackHelpful:
          clearFeedback ? null : feedbackHelpful ?? this.feedbackHelpful,
    );
  }

  @override
  List<Object?> get props => [feedbackHelpful];
}
