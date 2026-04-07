import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../expenses/models/expense.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../core/theme.dart';

class AddEditExpenseSheet extends ConsumerStatefulWidget {
  final Expense? expense;

  const AddEditExpenseSheet({super.key, this.expense});

  @override
  ConsumerState<AddEditExpenseSheet> createState() =>
      _AddEditExpenseSheetState();
}

class _AddEditExpenseSheetState extends ConsumerState<AddEditExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  late String _selectedCategory;
  late DateTime _selectedDate;

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        widget.expense?.category ?? CategoryColors.categories.first;
    _selectedDate = widget.expense?.date ?? DateTime.now();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toStringAsFixed(2);
      _noteController.text = widget.expense!.note ?? '';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final amount = double.parse(_amountController.text.replaceAll(',', ''));
    final note = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();

    final notifier = ref.read(expenseNotifierProvider.notifier);

    if (_isEditing) {
      final updated = widget.expense!.copyWith(
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        note: note,
      );
      await notifier.updateExpense(updated);
    } else {
      final expense = Expense(
        id: '',
        userId: user.uid,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        note: note,
        createdAt: DateTime.now(),
      );
      await notifier.addExpense(expense);
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: Theme.of(context).colorScheme),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final expenseState = ref.watch(expenseNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    ref.listen<AsyncValue<void>>(expenseNotifierProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: colorScheme.error,
            ),
          );
        },
      );
    });

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: const Color(0xFF2A2A4A)),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomPadding),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A5A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              _isEditing ? 'Edit Expense' : 'Add Expense',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Amount is required';
                final amount = double.tryParse(v.replaceAll(',', ''));
                if (amount == null || amount <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.attach_money_rounded),
                prefixText: '₹ ',
                prefixStyle: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              dropdownColor: const Color(0xFF1A1A2E),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: CategoryColors.categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: CategoryColors.forCategory(cat),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(cat),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(16),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(
                  DateFormat('MMMM dd, yyyy').format(_selectedDate),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              textInputAction: TextInputAction.done,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'Add a note...',
                prefixIcon: Icon(Icons.notes_rounded),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                if (_isEditing) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 56),
                        side: BorderSide(color: colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: _isEditing ? 2 : 1,
                  child: ElevatedButton(
                    onPressed: expenseState.isLoading ? null : _onSave,
                    child: expenseState.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isEditing ? 'Save Changes' : 'Add Expense'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
