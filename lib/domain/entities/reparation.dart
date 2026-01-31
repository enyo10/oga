import '../../helper/enums.dart';

class ReparationEntity {
  final String id;
  final String houseId;
  String? apartmentId;
  final String objet;
  final String description;
  final DateTime startDate;
  DateTime? endDate;
  String repairman;
  double repairCost;
  RepairStatus status;

  ReparationEntity({
    required this.id,
    this.apartmentId,
    required this.objet,
    required this.description,
    required this.startDate,
    required this.repairman,
    this.endDate,
    this.repairCost = 0,
    this.status = RepairStatus.onHold,
    required this.houseId,
  });
}
