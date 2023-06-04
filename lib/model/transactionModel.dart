import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String? id;
  final String? name;
  final int? amount;
  final String? categoryName;
  final String? categoryIcon;
  final String? type;
  final String? date;
  final String? walletId;

  const TransactionModel({
    this.id,
    this.name,
    this.amount,
    this.categoryName,
    this.categoryIcon,
    this.type,
    this.date,
    this.walletId,
  });

  factory TransactionModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return TransactionModel.fromMap(data);
  }

  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    return TransactionModel(
      id: data['id'],
      name: data['name'],
      amount: data['amount'],
      categoryName: data['categoryName'],
      categoryIcon: data['categoryIcon'],
      type: data['type'],
      date: data['date'],
      walletId: data['walletId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'type': type,
      'date': date,
      'walletId': walletId,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        categoryName,
        categoryIcon,
        type,
        date,
        walletId,
      ];
}
