import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsmart/providers/expense_provider.dart';
import 'package:spendsmart/screens/add_expense_screen.dart';
import '../utils/date_formatter.dart';

class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final index = args['index'] as int;
    final expense = context.watch<ExpenseProvider>().expenses[index];
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(expense.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddExpenseScreen(
                    existingExpense: expense,
                    existingIndex: index,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // 👇 RESPONSIVE WRAPPER STARTS HERE
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'expense-${expense.title}',
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        expense.emoji,
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    expense.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹${expense.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    formatDate(expense.date),
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // 👆 RESPONSIVE WRAPPER ENDS HERE
    );
  }
}
