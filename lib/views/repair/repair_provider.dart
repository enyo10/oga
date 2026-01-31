import 'package:flutter/foundation.dart';
import 'package:oga/views/repair/repair_service.dart';

import '../../models/repair.dart';

class RepairProvider extends ChangeNotifier {
  final List<Repair> _reparations = [];
  final RepairService _service;
  RepairProvider(this._service);

  List<Repair> get reparations => List.unmodifiable(_reparations);

  void addReparation(Repair rep) {
    _service.addRepair(rep);
    _reparations.add(rep);

    notifyListeners();
  }

  void updateReparation(Repair rep) {
    _service.updateRepair(rep);

  }

  void cancelReparation(String id) {
    _service.deleteRepair(id);
    _reparations.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  Future<void> loadRepairs(String houseId) async {
    final repairs = await _service.getRepairsByHouse(houseId);
    _reparations.clear();
    _reparations.addAll(repairs);
    notifyListeners();

  }
}
