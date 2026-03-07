import 'package:equatable/equatable.dart';

enum CropGrade { a, b, c }

enum CropType { pechay, tomato, eggplant, rice, mais, other }

class ScanRecord extends Equatable {
  final String id;
  final String cropName;
  final CropGrade grade;
  final DateTime scannedAt;
  final CropType cropType;

  const ScanRecord({
    required this.id,
    required this.cropName,
    required this.grade,
    required this.scannedAt,
    this.cropType = CropType.other,
  });

  String get gradeLabel => grade.name.toUpperCase();

  @override
  List<Object?> get props => [id, cropName, grade, scannedAt, cropType];
}
