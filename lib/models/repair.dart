import '../helper/enums.dart';

class Repair {
  final String id;
  final String houseId;
  String? apartmentId;
  final String objet;
  final String description;
  final DateTime startDate;
  DateTime? endDate;
  String repairman;
  double repairCost;
  RepairStatus status; // "en_attente", "en_cours", "terminé"

  Repair({
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

  void beginReparation() {
    status = RepairStatus.inProgress;
  }

  void endReparation(DateTime endDate, double finalCost) {
    this.endDate = endDate;
    repairCost = finalCost;
    status = RepairStatus.ended;
  }

  @override
  String toString() {
    return "Réparation $id ($status) : $description";
  }

  // Pour stockage JSON (Firebase, API, etc.)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "houseId": houseId,
      "apartmentId": apartmentId ?? "",
      "objet": objet,
      "description": description,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "repairman": repairman,
      "repairCost": repairCost,
      "status": status.key,
    };
  }

  factory Repair.fromJson(Map<String, dynamic> json) {
    return Repair(
      id: json["id"],
      houseId: json["houseId"],
      apartmentId: json["apartmentId"],
      objet: json["objet"],
      description: json["description"],
      startDate: DateTime.parse(json["startDate"]),
      endDate: json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
      repairman: json["repairman"],
      repairCost: (json["repairCost"] ?? 0).toDouble(),
      status: RepairStatus.fromKey(json["status"]),
    );
  }
}
