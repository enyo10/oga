import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/repair.dart';

class RepairService {
  final CollectionReference _repairs = FirebaseFirestore.instance.collection(
    'repairs',
  );

  Future<void> addRepair(Repair rep) {
    final repId = _repairs.doc().id;
    final data = rep.toJson();
    data["id"] = repId;
    return _repairs.doc(repId).set(data);
  }

  Future<void> updateRepair(Repair rep) {
    return _repairs.doc(rep.id).update(rep.toJson());
  }

  Future<void> deleteRepair(String id) {
    return _repairs.doc(id).delete();
  }

  Stream<List<Map<String, dynamic>>> get repairsStream {
    return _repairs.snapshots().map(
      (snap) => snap.docs.map((d) => d.data() as Map<String, dynamic>).toList(),
    );
  }

  Future<List<Repair>> getRepairsByHouse(String houseId) async {
    final query = await _repairs.where('houseId', isEqualTo: houseId).get();
    return query.docs
        .map((doc) => Repair.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
