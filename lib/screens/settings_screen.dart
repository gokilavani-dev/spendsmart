import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsmart/providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final budget = context.read<SettingsProvider>().budget;
    _budgetController.text = budget == 0.0 ? '' : budget.toString();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      // 👇 RESPONSIVE WRAPPER STARTS HERE
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Budget',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter budget amount',
                    prefixText: '${settingsProvider.currency} ',
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    final budget = double.tryParse(_budgetController.text);
                    if (budget != null) {
                      context.read<SettingsProvider>().setBudget(budget);
                    }
                  },
                  child: Text('Save Budget'),
                ),
                SizedBox(height: 32),
                Text(
                  'Select Currency',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: ['INR', 'USD', 'EUR'].map((currency) {
                    final isSelected = settingsProvider.currency == currency;
                    return ChoiceChip(
                      label: Text(currency),
                      selected: isSelected,
                      selectedColor: primary.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: isSelected ? primary : Colors.grey.shade700,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected ? primary : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (_) {
                        context.read<SettingsProvider>().setCurrency(currency);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      // 👆 RESPONSIVE WRAPPER ENDS HERE
    );
  }
}
