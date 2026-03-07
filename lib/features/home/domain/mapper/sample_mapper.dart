import 'package:injectable/injectable.dart';
import 'package:kubo_dex/features/home/data/contracts/sample_response_contract.dart';
import 'package:kubo_dex/features/home/domain/entities/sample_entity.dart';

@injectable
class SampleMapper {
  const SampleMapper();

  SampleEntity toEntity(SampleResponseContract contract) {
    return SampleEntity(
      id: contract.id,
      title: contract.title,
      description: contract.description,
    );
  }

  SampleResponseContract toContract(SampleEntity entity) {
    return SampleResponseContract(
      id: entity.id,
      title: entity.title,
      description: entity.description,
    );
  }

  List<SampleEntity> toEntityList(List<SampleResponseContract> contracts) {
    return contracts.map(toEntity).toList();
  }
}
