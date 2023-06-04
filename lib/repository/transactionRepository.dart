import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nabung/model/transactionModel.dart';

class TransactionRepository {
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  final String transaction = 'transaction';

  Future<void> createOrUpdate({
    required String userId,
    required TransactionModel transactionModel,
  }) async {
    await userReference
        .doc(userId)
        .collection(transaction)
        .doc(transactionModel.id!)
        .set(transactionModel.toMap());
  }

  Future<void> delete({
    required String userId,
    required String transactionId,
  }) async {
    await userReference
        .doc(userId)
        .collection(transaction)
        .doc(transactionId)
        .delete();
  }

  Stream<List<TransactionModel>> watch({
    required String userId,
  }) {
    Stream<QuerySnapshot> stream =
        userReference.doc(userId).collection(transaction).snapshots();

    return stream.map(
      (event) => event.docs
          .map((e) => TransactionModel.fromDocumentSnapshot(e))
          .toList(),
    );
  }
}
