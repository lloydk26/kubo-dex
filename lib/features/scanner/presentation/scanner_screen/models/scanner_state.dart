import 'package:equatable/equatable.dart';

enum ScannerStatus { initializing, ready, processing, done }

class ScannerState extends Equatable {
  final ScannerStatus status;
  final int nudgeIndex;
  final String? error;

  const ScannerState({
    this.status = ScannerStatus.initializing,
    this.nudgeIndex = 0,
    this.error,
  });

  bool get isReady => status == ScannerStatus.ready;
  bool get isProcessing => status == ScannerStatus.processing;
  bool get isDone => status == ScannerStatus.done;

  static const nudges = [
    'Move closer to the leaf for better analysis.',
    'Hold steady and aim for a clear leaf.',
    'Center the leaf in the frame.',
    'Ensure the leaf is well-lit.',
    'Avoid shadows on the leaf surface.',
  ];

  String get currentNudge => nudges[nudgeIndex % nudges.length];

  ScannerState copyWith({
    ScannerStatus? status,
    int? nudgeIndex,
    String? error,
  }) {
    return ScannerState(
      status: status ?? this.status,
      nudgeIndex: nudgeIndex ?? this.nudgeIndex,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, nudgeIndex, error];
}
