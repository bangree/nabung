import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nabung/model/colorModel.dart';

class WalletModel extends Equatable {
  final String? id;
  final String? name;
  final int? balance;
  final int? budgetPlan;
  final int? goal;
  final String? color;

  Color get walletColor {
    if (color != null) {
      Color selectedColor = ColorModel.colors
              .firstWhereOrNull(
                (element) => element.label == color,
              )
              ?.color ??
          const Color(0xFF5E657E);
      return selectedColor;
    }
    return const Color(0xFF5E657E);
  }

  const WalletModel({
    this.id,
    this.name,
    this.balance,
    this.budgetPlan,
    this.goal,
    this.color,
  });

  factory WalletModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return WalletModel.fromMap(data);
  }

  factory WalletModel.fromMap(Map<String, dynamic> data) {
    return WalletModel(
      id: data['id'],
      name: data['name'],
      balance: data['balance'],
      budgetPlan: data['budgetPlan'],
      goal: data['goal'],
      color: data['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'budgetPlan': budgetPlan,
      'goal': goal,
      'color': color,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        balance,
        budgetPlan,
        goal,
        color,
      ];
}
