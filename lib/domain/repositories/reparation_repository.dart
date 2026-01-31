import '../entities/reparation.dart';

abstract class ReparationRepository {
  Future<void> createRepair(ReparationEntity repair);
  Future<List<ReparationEntity>> getRepairsByHouse(String houseId);
  Future<void> updateRepair(ReparationEntity repair);
}
