import 'dart:convert';

import 'package:uuid/uuid.dart';

enum TransactionType { income, expense }

extension TransactionTypeExtension on TransactionType {
  String get nameSingular {
    switch (this) {
      case TransactionType.income:
        return 'Receita';
      case TransactionType.expense:
        return 'Despesa';
    }
  }

  String get namePlural {
    switch (this) {
      case TransactionType.income:
        return 'Receitas';
      case TransactionType.expense:
        return 'Despesas';
    }
  }
}
class TransactionEntity {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;

  // Instância estática do Uuid para usar generate()
  static final Uuid _uuid = Uuid();

  TransactionEntity({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  }) : id = id ?? _uuid.v4();

  TransactionEntity copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toUtc().toIso8601String(),
      'type': type.name,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory TransactionEntity.fromMap(Map<String, dynamic> map) {
    return TransactionEntity(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']).toLocal(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
    );
  }

  factory TransactionEntity.sampleExpense() {
    return TransactionEntity(
      title: 'Almoço',
      amount: 30.0,
      date: DateTime.now(),
      type: TransactionType.expense,
    );
  }

  factory TransactionEntity.sampleIncome() {
    return TransactionEntity(
      title: 'Salário',
      amount: 2500.0,
      date: DateTime.now(),
      type: TransactionType.income,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TransactionEntity &&
      other.id == id &&
      other.title == title &&
      other.amount == amount &&
      other.date == date &&
      other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      amount.hashCode ^
      date.hashCode ^
      type.hashCode;
  }
}
