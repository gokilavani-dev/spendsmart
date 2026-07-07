import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendsmart/models/transaction_item.dart';
import 'package:spendsmart/providers/expense_provider.dart';
import 'package:spendsmart/providers/income_provider.dart';
import 'package:spendsmart/providers/settings_provider.dart';
import 'package:spendsmart/models/payment_method.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../utils/date_formatter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentPage = 0;
  bool _isDialOpen = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ExpenseProvider>().loadExpenses();
        context.read<IncomeProvider>().loadIncomes();
      }
    });
  }

  // ---------- Balance Carousel ----------

  List<Map<String, dynamic>> _buildCardData(
    List<Expense> expenses,
    List<Income> incomes,
  ) {
    final cashExpense = expenses
        .where((e) => e.paymentMethod == PaymentMethod.cash)
        .fold(0.0, (sum, e) => sum + e.amount);
    final cardExpense = expenses
        .where((e) => e.paymentMethod == PaymentMethod.card)
        .fold(0.0, (sum, e) => sum + e.amount);
    final totalExpense = cashExpense + cardExpense;

    final cashIncome = incomes
        .where((i) => i.paymentMethod == PaymentMethod.cash)
        .fold(0.0, (sum, i) => sum + i.amount);
    final cardIncome = incomes
        .where((i) => i.paymentMethod == PaymentMethod.card)
        .fold(0.0, (sum, i) => sum + i.amount);
    final totalIncome = cashIncome + cardIncome;

    return [
      {
        'label': 'Total',
        'balance': totalIncome - totalExpense,
        'income': totalIncome,
        'expense': totalExpense,
      },
      {
        'label': 'Cash',
        'balance': cashIncome - cashExpense,
        'income': cashIncome,
        'expense': cashExpense,
      },
      {
        'label': 'Card',
        'balance': cardIncome - cardExpense,
        'income': cardIncome,
        'expense': cardExpense,
      },
    ];
  }

  Widget _miniStat(IconData icon, String label, double value, Color color) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.white,
          child: Icon(icon, size: 14, color: color),
        ),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.white60, fontSize: 9)),
            Text(
              '₹${value.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleBalanceCard({
    required String label,
    required double balance,
    required double income,
    required double expense,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white70,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '₹${balance.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _miniStat(
                Icons.arrow_downward,
                'INCOME',
                income,
                Colors.greenAccent,
              ),
              _miniStat(
                Icons.arrow_upward,
                'EXPENSE',
                expense,
                Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCarousel(List<Map<String, dynamic>> cardData) {
    return Column(
      children: [
        SizedBox(
          height: 175,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: cardData.length,
            itemBuilder: (context, index) {
              final data = cardData[index];
              return _buildSingleBalanceCard(
                label: data['label'],
                balance: data['balance'],
                income: data['income'],
                expense: data['expense'],
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(cardData.length, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ---------- Budget Card ----------

  Widget _buildBudgetCard(double totalSpent, double budget, Color barColor) {
    final percent = budget == 0.0 ? 0.0 : (totalSpent / budget).clamp(0, 1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Budget',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                '${(percent * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: barColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent.toDouble(),
              minHeight: 14,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '₹${totalSpent.toStringAsFixed(0)} of ₹${budget.toStringAsFixed(0)} spent',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ---------- Speed Dial FAB ----------

  Widget _buildMiniFab({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Text(label, style: TextStyle(fontSize: 12)),
        ),
        SizedBox(width: 8),
        FloatingActionButton(
          mini: true,
          heroTag: label,
          backgroundColor: color,
          onPressed: onTap,
          child: Icon(icon, color: Colors.white),
        ),
      ],
    );
  }

  // ---------- Transaction merge helper ----------

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

  // ---------- Build ----------

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>().expenses;
    final incomes = context.watch<IncomeProvider>().incomes;
    final budget = context.watch<SettingsProvider>().budget;
    final double totalSpent = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final barColor = totalSpent > budget * 0.8
        ? Colors.red.shade400
        : Theme.of(context).colorScheme.primary;
    final cardData = _buildCardData(expenses, incomes);
    final transactionList = _buildTransactionList(expenses, incomes);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SpendSmart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _buildBalanceCarousel(cardData),
                SizedBox(height: 20),

                _buildBudgetCard(totalSpent, budget, barColor),
                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/transactions'),
                      child: Text('See All'),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                if (transactionList.isEmpty)
                  _buildEmptyState()
                else
                  for (int i = 0; i < transactionList.length && i < 5; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TransactionTile(item: transactionList[i]),
                    ),
                SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isDialOpen) ...[
            _buildMiniFab(
              icon: Icons.arrow_upward,
              label: 'Add Income',
              color: Colors.green,
              onTap: () {
                setState(() => _isDialOpen = false);
                Navigator.pushNamed(context, '/add-income');
              },
            ),
            SizedBox(height: 12),
            _buildMiniFab(
              icon: Icons.arrow_downward,
              label: 'Add Expense',
              color: Colors.red,
              onTap: () {
                setState(() => _isDialOpen = false);
                Navigator.pushNamed(context, '/add');
              },
            ),
            SizedBox(height: 12),
          ],
          FloatingActionButton(
            heroTag: 'main_fab',
            onPressed: () => setState(() => _isDialOpen = !_isDialOpen),
            child: AnimatedRotation(
              turns: _isDialOpen ? 0.125 : 0,
              duration: Duration(milliseconds: 200),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final TransactionItem item;

  const TransactionTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final amountColor = item.isIncome
        ? Colors.green.shade600
        : Colors.red.shade600;
    final sign = item.isIncome ? '+' : '-';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.isIncome
            ? null
            : () => Navigator.pushNamed(
                context,
                '/detail',
                arguments: {'index': item.originalIndex},
              ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(item.emoji, style: TextStyle(fontSize: 20)),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      formatDate(item.date),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$sign₹${item.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildEmptyState() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 60),
    child: Column(
      children: [
        Icon(
          Icons.receipt_long_outlined,
          size: 80,
          color: Colors.grey.shade300,
        ),
        SizedBox(height: 16),
        Text(
          'No transactions yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Tap the + button to add your first expense or income',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
