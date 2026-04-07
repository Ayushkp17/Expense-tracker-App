import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';
import '../../auth/providers/auth_provider.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return ref.watch(expenseRepositoryProvider).watchExpenses(user.uid);
});

final selectedMonthProvider = NotifierProvider<SelectedMonthNotifier, DateTime>(
  SelectedMonthNotifier.new,
);

class SelectedMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void previous() {
    state = DateTime(state.year, state.month - 1);
  }

  void next() {
    final now = DateTime.now();
    final next = DateTime(state.year, state.month + 1);
    if (!next.isAfter(DateTime(now.year, now.month))) {
      state = next;
    }
  }
}

final monthlyExpensesProvider = Provider<List<Expense>>((ref) {
  final allExpenses = ref.watch(expensesStreamProvider).value ?? [];
  final selectedMonth = ref.watch(selectedMonthProvider);
  return allExpenses.where((e) {
    return e.date.year == selectedMonth.year &&
        e.date.month == selectedMonth.month;
  }).toList();
});

final totalMonthlySpendProvider = Provider<double>((ref) {
  final expenses = ref.watch(monthlyExpensesProvider);
  return expenses.fold(0.0, (sum, e) => sum + e.amount);
});

final categoryTotalsProvider = Provider<Map<String, double>>((ref) {
  final expenses = ref.watch(monthlyExpensesProvider);
  final totals = <String, double>{};
  for (final e in expenses) {
    totals[e.category] = (totals[e.category] ?? 0) + e.amount;
  }
  return totals;
});

final dailyTotalsProvider = Provider<Map<int, double>>((ref) {
  final expenses = ref.watch(monthlyExpensesProvider);
  final totals = <int, double>{};
  for (final e in expenses) {
    totals[e.date.day] = (totals[e.date.day] ?? 0) + e.amount;
  }
  return totals;
});

// ---------------------------------------------------------------------------
// ExpenseNotifier — Riverpod 3 Notifier API
// ---------------------------------------------------------------------------
class ExpenseNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  String get _userId => ref.read(currentUserProvider)?.uid ?? '';

  Future<void> addExpense(Expense expense) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(expenseRepositoryProvider).addExpense(expense),
    );
  }

  Future<void> updateExpense(Expense expense) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(expenseRepositoryProvider).updateExpense(expense),
    );
  }

  Future<void> deleteExpense(String expenseId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () =>
          ref.read(expenseRepositoryProvider).deleteExpense(_userId, expenseId),
    );
  }

  void resetState() => state = const AsyncValue.data(null);
}

final expenseNotifierProvider =
    NotifierProvider<ExpenseNotifier, AsyncValue<void>>(ExpenseNotifier.new);
