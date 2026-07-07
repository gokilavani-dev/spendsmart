import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsmart/models/payment_method.dart';
import 'package:spendsmart/providers/income_provider.dart';
import '../models/income.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  String _amountString = '0';
  final _titleController = TextEditingController();
  final _emojiController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  String? _errorText;

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
    final green = Colors.green.shade600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/income.png', width: 26, height: 26),
            SizedBox(width: 8),
            Text('Add Income'),
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
                Text(
                  '₹$_amountString',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: green,
                  ),
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
                        decoration: InputDecoration(
                          labelText: 'Title (e.g. Salary)',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: Icon(Icons.calendar_month, size: 18, color: green),
                  label: Text(
                    "Date: ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
                    style: TextStyle(color: green),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: green.withOpacity(0.4)),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  child: Text("Add Income"),
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

    final newIncome = Income(
      emoji: _emojiController.text.trim().isEmpty
          ? '💰'
          : _emojiController.text.trim(),
      title: _titleController.text.trim(),
      amount: amount,
      date: _selectedDate,
      paymentMethod: _selectedPaymentMethod,
    );

    context.read<IncomeProvider>().addIncome(newIncome);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _emojiController.dispose();
    super.dispose();
  }
}
