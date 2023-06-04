import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nabung/model/walletModel.dart';

class WalletRepository {
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  final String wallet = 'wallet';

  Future<void> createOrUpdate({
    required String userId,
    required WalletModel walletModel,
  }) async {
    await userReference
        .doc(userId)
        .collection(wallet)
        .doc(walletModel.id!)
        .set(walletModel.toMap());
  }

  Stream<List<WalletModel>> watch({
    required String userId,
  }) {
    Stream<QuerySnapshot> stream =
        userReference.doc(userId).collection(wallet).snapshots();

    return stream.map(
      (event) =>
          event.docs.map((e) => WalletModel.fromDocumentSnapshot(e)).toList(),
    );
  }
}
