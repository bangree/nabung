import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nabung/model/colorModel.dart';

class WalletModel extends Equatable {
  final String? id;
  final String? name;
  final int? balance;
  final int? budgetPlan;
  final int? goal;
  final String? color;
  final int? updatedAt;

  String get textBalance => currencyFormat(value: balance);

  String get textBudgetPlan => currencyFormat(value: budgetPlan);

  String get textGoal => currencyFormat(value: goal);

  String get dateUpdatedAt {
    DateTime dateTime = DateTime.now();
    if (updatedAt != null) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(updatedAt!);
    }
    return DateFormat('EEE, dd MMM yyyy').format(dateTime);
  }

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

  String currencyFormat({int? value}) {
    if (value == null) return 'Rp 0';
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  const WalletModel({
    this.id,
    this.name,
    this.balance,
    this.budgetPlan,
    this.goal,
    this.color,
    this.updatedAt,
  });

  WalletModel copyWith({
    String? id,
    String? name,
    int? balance,
    int? budgetPlan,
    int? goal,
    String? color,
    int? updatedAt,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      budgetPlan: budgetPlan ?? this.budgetPlan,
      goal: goal ?? this.goal,
      color: color ?? this.color,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
      updatedAt: data['updatedAt'],
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
      'updatedAt': updatedAt,
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
        updatedAt,
      ];
}
