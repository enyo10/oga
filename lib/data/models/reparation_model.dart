import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oga/domain/entities/reparation.dart';

import '../../helper/enums.dart';

class ReparationModel extends ReparationEntity {
  ReparationModel({
    required super.id,
    required super.houseId,
    super.apartmentId,
    required super.objet,
    required super.description,
    required super.startDate,
    required super.repairman,
    super.endDate,
    super.repairCost,
    super.status,
  });

  factory ReparationModel.fromMap(Map<String, dynamic> map) {
    return ReparationModel(
      id: map['id'],
      houseId: map['houseId'],
      apartmentId: map['apartmentId'],
      objet: map['objet'],
      description: map['description'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
      repairman: map['repairman'],
      repairCost: (map['repairCost'] ?? 0).toDouble(),
      status: RepairStatus.fromKey(map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'houseId': houseId,
      'apartmentId': apartmentId,
      'objet': objet,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'repairman': repairman,
      'repairCost': repairCost,
      'status': status.key,
    };
  }
}
