import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsmart/models/category.dart';
import 'package:spendsmart/models/payment_method.dart';
import 'package:spendsmart/providers/expense_provider.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? existingExpense;
  final int? existingIndex;
  const AddExpenseScreen({super.key, this.existingExpense, this.existingIndex});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String _amountString = '0';
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _emojiController = TextEditingController();
  Category _selectedCategory = Category.others;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.existingExpense != null) {
      final e = widget.existingExpense!;
      _amountString = e.amount.toString();
      _titleController.text = e.title;
      _selectedDate = e.date;
      _emojiController.text = e.emoji;
      _selectedCategory = e.category;
      _selectedPaymentMethod = e.paymentMethod;
    }
  }

  // ---------- Keypad logic ----------

  void _onKeyTap(String key) {
    setState(() {
      _errorText = null;
      if (key == 'back') {
        _amountString = _amountString.length > 1
            ? _amountString.substring(0, _amountString.length - 1)
            : '0';
      } else if (key == '.') {
        if (!_amountString.contains('.')) _amountString += '.';
      } else {
        _amountString = _amountString == '0' ? key : _amountString + key;
      }
    });
  }

  Widget _buildKeypad() {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '.',
      '0',
      'back',
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      children: keys.map((k) {
        return TextButton(
          onPressed: () => _onKeyTap(k),
          child: k == 'back'
              ? Icon(Icons.backspace_outlined, size: 20)
              : Text(
                  k,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
        );
      }).toList(),
    );
  }

  // ---------- Category grid ----------

  Widget _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      children: Category.values.map((cat) {
        final isSelected = _selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        )
                      : null,
                ),
                child: ClipOval(
                  child: Image.asset(cat.assetPath, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 4),
              Text(cat.name, style: TextStyle(fontSize: 10)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/expense.png', width: 26, height: 26),
            SizedBox(width: 8),
            Text(
              widget.existingExpense == null ? 'Add Expense' : 'Edit Expense',
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Big amount display
                Text(
                  '₹$_amountString',
                  style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                ),
                if (_errorText != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      _errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 12),

                // Cash / Card chips
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Center(child: Text('Cash')),
                        selected: _selectedPaymentMethod == PaymentMethod.cash,
                        onSelected: (_) => setState(
                          () => _selectedPaymentMethod = PaymentMethod.cash,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ChoiceChip(
                        label: Center(child: Text('Card')),
                        selected: _selectedPaymentMethod == PaymentMethod.card,
                        onSelected: (_) => setState(
                          () => _selectedPaymentMethod = PaymentMethod.card,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                _buildKeypad(),
                SizedBox(height: 16),

                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        controller: _emojiController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: 'Emoji'),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),

                Text(
                  'Select Category',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                _buildCategoryGrid(),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: Icon(Icons.calendar_month, size: 18, color: primary),
                  label: Text(
                    "Date: ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
                    style: TextStyle(color: primary),
                  ),
                ),

                SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    widget.existingExpense == null ? "Add" : "Update",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final amount = double.tryParse(_amountString);
    if (amount == null || amount <= 0) {
      setState(() => _errorText = 'Enter a valid amount');
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      setState(() => _errorText = 'Title is required');
      return;
    }

    final newExpense = Expense(
      emoji: _emojiController.text.trim().isEmpty
          ? '🧾'
          : _emojiController.text.trim(),
      title: _titleController.text.trim(),
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
      paymentMethod: _selectedPaymentMethod,
    );

    if (widget.existingIndex == null) {
      context.read<ExpenseProvider>().addExpense(newExpense);
    } else {
      context.read<ExpenseProvider>().updateExpense(
        widget.existingIndex!,
        newExpense,
      );
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _emojiController.dispose();
    super.dispose();
  }
}
