import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../expenses/models/expense.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../core/theme.dart';
import '../../widgets/add_edit_expense_sheet.dart';

class ExpenseListTile extends ConsumerWidget {
  final Expense expense;

  const ExpenseListTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = CategoryColors.forCategory(expense.category);
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: colorScheme.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.delete_outline_rounded, color: colorScheme.error),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(context);
      },
      onDismissed: (_) {
        ref.read(expenseNotifierProvider.notifier).deleteExpense(expense.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Expense deleted'),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () => _showEditSheet(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _categoryIcon(expense.category),
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.category,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      if (expense.note != null && expense.note!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          expense.note!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(expense.date),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${NumberFormat('#,##0.00').format(expense.amount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        expense.category.split(' ').first,
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditExpenseSheet(expense: expense),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text(
          'Are you sure you want to delete this ${expense.category} expense?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Food & Dining':
        return Icons.restaurant_rounded;
      case 'Transport':
        return Icons.directions_car_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Entertainment':
        return Icons.movie_rounded;
      case 'Health':
        return Icons.favorite_rounded;
      case 'Utilities':
        return Icons.bolt_rounded;
      case 'Education':
        return Icons.school_rounded;
      case 'Travel':
        return Icons.flight_rounded;
      case 'Rent & Housing':
        return Icons.home_rounded;
      case 'Savings':
        return Icons.savings_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }
}
