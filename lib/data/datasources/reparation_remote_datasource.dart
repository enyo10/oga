import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oga/data/models/reparation_model.dart';

class ReparationRemoteDataSource {
  final FirebaseFirestore firestore;

  ReparationRemoteDataSource(this.firestore);

  Future<void> createRepair(ReparationModel model) async {
    await firestore.collection('repairs').doc(model.id).set(model.toMap());
  }

  Future<List<ReparationModel>> getRepairsByHouse(String houseId) async {
    final query =
        await firestore
            .collection('repairs')
            .where('houseId', isEqualTo: houseId)
            .get();

    return query.docs
        .map((doc) => ReparationModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> updateRepair(ReparationModel model) async {
    await firestore.collection('repairs').doc(model.id).update(model.toMap());
  }
}
