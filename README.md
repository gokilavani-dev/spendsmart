# 💰 SpendSmart — Personal Expense Tracker

A full-featured personal finance tracker built with **Flutter**, developed session-by-session while learning core Flutter fundamentals — from basic widgets to local persistence, state management, and polished UI/UX.

---

## ✨ Features

- **Expense & Income Tracking** — Add, edit, and delete transactions with category tagging
- **Cash / Card Payment Method** — Track spending by payment source
- **Swipeable Balance Carousel** — Total, Cash, and Card balances with income/expense breakdown
- **Category System** — 9 categories (Groceries, Food, Travel, Entertainment, Stay, Shopping, Bills, Health, Others) with custom icon assets
- **Monthly Budget Tracking** — Visual progress bar with over-budget warnings
- **Multi-Currency Display** — Live conversion to USD, EUR, GBP via REST API
- **Local Persistence** — All data stored offline using Hive
- **Form Validation** — Full validation on all input fields
- **Swipe-to-Delete** — With confirmation dialog to prevent accidental deletion
- **Custom Theming** — Teal/Green Material 3 color scheme applied app-wide
- **Responsive Layout** — Adapts cleanly from mobile to desktop window sizes
- **Speed-Dial FAB** — Quick access to Add Expense / Add Income
- **Custom App Icon** — Generated and configured via `flutter_launcher_icons`

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Provider (`ChangeNotifier`) |
| Local Database | Hive (NoSQL, with custom `TypeAdapter`s) |
| Networking | `http` package + REST API (currency rates) |
| Persistence | SharedPreferences (settings) |
| UI | Material 3, custom `ColorScheme.fromSeed` |

---

## 🏗️ Architecture Highlights

- **Provider pattern** for clean separation between UI and business logic (`ExpenseProvider`, `IncomeProvider`, `SettingsProvider`)
- **Custom Hive TypeAdapters** for `Expense`, `Income`, `Category` (enum), and `PaymentMethod` (enum)
- **Dual-mode screens** — a single `AddExpenseScreen` handles both create and edit flows via optional constructor parameters
- **Reactive detail views** — screens read live data from Provider by index instead of caching stale snapshots, avoiding a subtle stale-data bug found during development
- **Unified transaction model** — a lightweight `TransactionItem` wrapper merges `Expense` and `Income` records into a single sorted, color-coded list

---

## 📚 What I Learned

This project was built as a structured, session-based learning journey covering:

- StatelessWidget vs StatefulWidget, `setState`
- Forms, validation, and navigation with arguments
- Local storage with Hive and code generation (`build_runner`)
- Async programming — `Future`, `FutureBuilder`, REST API integration
- State management with Provider (`watch` vs `read`, `notifyListeners`)
- Persistent settings with SharedPreferences
- UI polish — theming, responsiveness, empty states, animations
- Real debugging — schema migration crashes, stale navigation data, and fixing them properly instead of working around them

---

## 🚀 Getting Started

```bash
git clone <repo-url>
cd spendsmart
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## 📸 Screenshots

<img width="437" height="933" alt="image" src="https://github.com/user-attachments/assets/519cfacb-43d5-4581-a0cf-ef33f31f85c5" />  <img width="452" height="921" alt="image" src="https://github.com/user-attachments/assets/b60453bb-5676-45d7-b06d-a25f532428ae" />

<img width="453" height="944" alt="image" src="https://github.com/user-attachments/assets/6a2f87af-543f-4de0-9494-85548718630a" />  <img width="444" height="945" alt="image" src="https://github.com/user-attachments/assets/4c04257e-e85c-45f7-b6d1-181fd66d3ba2" />

<img width="435" height="940" alt="image" src="https://github.com/user-attachments/assets/d3dde624-6ff6-4b3b-a288-d4293029591b" />  <img width="441" height="941" alt="image" src="https://github.com/user-attachments/assets/56dafbaa-6662-4da0-9927-cc2d73fce321" />

---

## 🔮 Roadmap

- [ ] Category-wise pie chart (`fl_chart`)
- [ ] Month-wise transaction filtering
- [ ] Dark mode
- [ ] Swipe-to-delete for merged transaction list

---

Built with ❤️ using Flutter.
