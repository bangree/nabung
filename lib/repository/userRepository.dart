import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nabung/model/userModel.dart';

class UserRepository {
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  Stream<UserModel> watch({
    required String userId,
  }) {
    Stream<DocumentSnapshot> stream = userReference.doc(userId).snapshots();

    return stream.map(
      (event) => UserModel.fromDocumentSnapshot(event),
    );
  }

  Future<void> update({required UserModel user}) async {
    await userReference.doc(user.id!).set(user.toMap());
  }
}
