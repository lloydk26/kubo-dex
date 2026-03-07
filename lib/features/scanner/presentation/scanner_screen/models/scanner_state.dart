import 'package:equatable/equatable.dart';
import 'package:kubo_dex/features/diagnosis/domain/entities/diagnosis_result.dart';

enum ScannerStatus { initializing, ready, processing, done, error }

class ScannerState extends Equatable {
  final ScannerStatus status;
  final int nudgeIndex;
  final String? error;
  final DiagnosisResult? result;

  const ScannerState({
    this.status = ScannerStatus.initializing,
    this.nudgeIndex = 0,
    this.error,
    this.result,
  });

  bool get isReady => status == ScannerStatus.ready;
  bool get isProcessing => status == ScannerStatus.processing;
  bool get isDone => status == ScannerStatus.done;
  bool get hasError => status == ScannerStatus.error;

  static const nudges = [
    'Lumapit nang konti — para mas malinaw ang scan.',
    'Huwag gumalaw — hold steady lang.',
    'I-center ang halaman sa loob ng frame.',
    'Siguraduhing maliwanag ang ilaw sa halaman.',
    'Iwasan ang anino sa dahon o bunga.',
    'Ang buong dahon dapat nasa loob ng kahon.',
    'Subukan muli — medyo malayo pa.',
  ];

  String get currentNudge => nudges[nudgeIndex % nudges.length];

  ScannerState copyWith({
    ScannerStatus? status,
    int? nudgeIndex,
    String? error,
    DiagnosisResult? result,
  }) {
    return ScannerState(
      status: status ?? this.status,
      nudgeIndex: nudgeIndex ?? this.nudgeIndex,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [status, nudgeIndex, error, result];
}
