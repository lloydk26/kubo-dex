import 'package:equatable/equatable.dart';

class SampleEntity extends Equatable {
  static const SampleEntity empty = SampleEntity(
    id: '',
    title: '',
  );

  final String id;
  final String title;
  final String? description;

  const SampleEntity({
    required this.id,
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [id, title, description];
}
