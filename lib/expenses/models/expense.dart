import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    required this.createdAt,
  });

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      userId: data['userId'] as String,
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] as String,
      date: (data['date'] as Timestamp).toDate(),
      note: data['note'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Expense copyWith({
    String? id,
    String? userId,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
