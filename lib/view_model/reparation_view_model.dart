import 'package:flutter/cupertino.dart';

import '../domain/entities/reparation.dart';
import '../domain/repositories/reparation_repository.dart';

class ReparationViewModel extends ChangeNotifier {
  final ReparationRepository repository;

  ReparationViewModel(this.repository);

  List<ReparationEntity> repairs = [];
  bool loading = false;

  Future<void> loadRepairs(String houseId) async {
    loading = true;
    notifyListeners();

    repairs = await repository.getRepairsByHouse(houseId);

    loading = false;
    notifyListeners();
  }

  Future<void> addRepair(ReparationEntity repair) async {
    await repository.createRepair(repair);
    repairs.add(repair);
    notifyListeners();
  }
}
