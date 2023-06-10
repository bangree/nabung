import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nabung/model/categoryModel.dart';

class CategoryRepository {
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  final String category = 'category';

  Future<void> create({
    required String userId,
    required CategoryModel categoryModel,
  }) async {
    await userReference
        .doc(userId)
        .collection(category)
        .doc(categoryModel.label)
        .set(categoryModel.toMap());
  }

  Stream<List<CategoryModel>> watch({
    required String userId,
  }) {
    Stream<QuerySnapshot> stream =
        userReference.doc(userId).collection(category).snapshots();

    return stream.map(
      (event) =>
          event.docs.map((e) => CategoryModel.fromDocumentSnapshot(e)).toList(),
    );
  }

  Future<void> delete({
    required String userId,
    required String label,
  }) async {
    await userReference.doc(userId).collection(category).doc(label).delete();
  }
}
