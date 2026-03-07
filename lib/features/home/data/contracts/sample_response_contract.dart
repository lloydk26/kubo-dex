import 'package:json_annotation/json_annotation.dart';
import 'package:kubo_dex/core/data/json/json_serializable_object.dart';

part 'sample_response_contract.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SampleResponseContract extends JsonSerializableObject {
  final String id;
  final String title;
  final String? description;

  const SampleResponseContract({
    required this.id,
    required this.title,
    this.description,
  });

  factory SampleResponseContract.fromJson(Map<String, dynamic> json) =>
      _$SampleResponseContractFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SampleResponseContractToJson(this);
}
