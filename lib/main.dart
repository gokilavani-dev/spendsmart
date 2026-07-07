import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spendsmart/models/category.dart';
import 'package:spendsmart/models/income.dart';
import 'package:spendsmart/models/payment_method.dart';
import 'package:spendsmart/providers/expense_provider.dart';
import 'package:spendsmart/models/expense.dart';
import 'package:spendsmart/providers/income_provider.dart';
import 'package:spendsmart/providers/settings_provider.dart';
import 'package:spendsmart/screens/add_expense_screen.dart';
import 'package:spendsmart/screens/expense_detail_screen.dart';
import 'package:spendsmart/screens/income_screen.dart';
import 'package:spendsmart/screens/settings_screen.dart';
import 'package:spendsmart/screens/transactions_screen.dart';
import './screens/dashboard_screen.dart';

void main() async {
  // Step 1: Flutter engine ready panna
  WidgetsFlutterBinding.ensureInitialized();

  // Step 2: Hive initialize
  await Hive.initFlutter();

  // Step 3: Register our translator
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(PaymentMethodAdapter()); // 👈 புதுசா சேருங்க
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(IncomeAdapter());

  // Step 4: Open the box (our table)
  // await Hive.deleteBoxFromDisk('expenses');
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<Income>('incomes');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => IncomeProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = SettingsProvider();
            provider.loadSettings(); // call loadSettings here!
            return provider;
          },
        ),
      ],
      child: SpendSmartApp(),
    ),
  );
}

class SpendSmartApp extends StatelessWidget {
  const SpendSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF0D9488), // Teal 600
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Color(0xFFF8FAFA),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1F2937),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0D9488),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF0D9488),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardScreen(),
        '/add': (context) => AddExpenseScreen(),
        '/detail': (context) => ExpenseDetailScreen(),
        '/settings': (context) => SettingsScreen(),
        '/transactions': (context) => TransactionsScreen(),
        '/add-income': (context) => AddIncomeScreen(),
      },
    );
  }
}
