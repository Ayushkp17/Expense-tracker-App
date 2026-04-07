import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firestore.collection('users').doc(userId).collection('expenses');

  Stream<List<Expense>> watchExpenses(String userId) {
    return _collection(userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Expense.fromFirestore).toList());
  }

  Future<List<Expense>> getExpensesByMonth(
    String userId,
    int year,
    int month,
  ) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    final snap = await _collection(userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .get();

    return snap.docs.map(Expense.fromFirestore).toList();
  }

  Future<void> addExpense(Expense expense) async {
    await _collection(expense.userId).add(expense.toFirestore());
  }

  Future<void> updateExpense(Expense expense) async {
    await _collection(
      expense.userId,
    ).doc(expense.id).update(expense.toFirestore());
  }

  Future<void> deleteExpense(String userId, String expenseId) async {
    await _collection(userId).doc(expenseId).delete();
  }
}
