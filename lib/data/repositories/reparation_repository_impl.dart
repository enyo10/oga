import '../../domain/entities/reparation.dart';
import '../../domain/repositories/reparation_repository.dart';
import '../datasources/reparation_remote_datasource.dart';
import '../models/reparation_model.dart';

class RepairRepositoryImpl implements ReparationRepository {
  final ReparationRemoteDataSource remote;

  RepairRepositoryImpl(this.remote);

  @override
  Future<void> createRepair(ReparationEntity repair) {
    final model = ReparationModel(
      id: repair.id,
      houseId: repair.houseId,
      apartmentId: repair.apartmentId,
      objet: repair.objet,
      description: repair.description,
      startDate: repair.startDate,
      endDate: repair.endDate,
      repairman: repair.repairman,
      repairCost: repair.repairCost,
      status: repair.status,
    );
    return remote.createRepair(model);
  }

  @override
  Future<List<ReparationEntity>> getRepairsByHouse(String houseId) {
    return remote.getRepairsByHouse(houseId);
  }

  @override
  Future<void> updateRepair(ReparationEntity repair) {
    final model = ReparationModel(
      id: repair.id,
      houseId: repair.houseId,
      apartmentId: repair.apartmentId,
      objet: repair.objet,
      description: repair.description,
      startDate: repair.startDate,
      endDate: repair.endDate,
      repairman: repair.repairman,
      repairCost: repair.repairCost,
      status: repair.status,
    );
    return remote.updateRepair(model);
  }
}
