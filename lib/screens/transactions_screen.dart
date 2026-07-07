import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsmart/models/transaction_item.dart';
import 'package:spendsmart/providers/expense_provider.dart';
import 'package:spendsmart/providers/income_provider.dart';
import 'package:spendsmart/models/expense.dart';
import 'package:spendsmart/models/income.dart';
import 'package:spendsmart/screens/dashboard_screen.dart'; // for TransactionTile reuse

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  // 👇 No context.watch here anymore — just plain data transformation
  List<TransactionItem> _buildTransactionList(
    List<Expense> expenses,
    List<Income> incomes,
  ) {
    final items = <TransactionItem>[];
    for (int i = 0; i < expenses.length; i++) {
      items.add(TransactionItem.fromExpense(expenses[i], i));
    }
    for (int i = 0; i < incomes.length; i++) {
      items.add(TransactionItem.fromIncome(incomes[i], i));
    }
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // 👇 watch() called directly inside build() — correct usage
    final expenses = context.watch<ExpenseProvider>().expenses;
    final incomes = context.watch<IncomeProvider>().incomes;
    final transactionList = _buildTransactionList(expenses, incomes);

    return Scaffold(
      appBar: AppBar(title: Text('All Transactions')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: transactionList.isEmpty
                ? Center(child: Text('No transactions yet'))
                : ListView.builder(
                    itemCount: transactionList.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TransactionTile(item: transactionList[i]),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
