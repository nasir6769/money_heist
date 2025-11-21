import 'package:flutter/material.dart';
import 'services/supabase_service.dart';
import 'screens/my_investments_screen.dart';


// Screens
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/biometric_screen.dart';
import 'screens/home_screen.dart';

import 'screens/upi_payment_screen.dart';
import 'screens/scan_qr_screen.dart';
import 'screens/pay_phone_screen.dart';

import 'screens/stocks_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/my_balance_screen.dart';

import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_money_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme =
        ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark);

    final theme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF001B10),
      colorScheme: scheme,
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoneyHeist',
      theme: theme,
      home: const AuthGate(),   // 👈 START HERE
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/biometric': (context) => const BiometricScreen(),
        '/home': (context) => const HomeScreen(),

        // UPI Payment Flow
        '/upi': (context) => const UpiPaymentScreen(),
        '/scan-qr': (context) => const ScanQrScreen(),
        '/pay-phone': (context) => const PayPhoneScreen(),

        // Stocks
        '/stocks': (context) => const StocksScreen(),

        // Wallet
        '/wallet': (context) => const WalletScreen(),

        // My Balance
        '/mybalance': (context) => const MyBalanceScreen(),

        // Profile
        '/profile': (context) => const ProfileScreen(),

        // Settings
        '/settings': (context) => const SettingsScreen(),

        '/addmoney': (context) => const AddMoneyScreen(),
        '/myinvestments': (context) => const MyInvestmentsScreen(),

      },
    );
  }
}

/// ----------------------------------------------------------------------------
///   AUTH GATE — Checks if user is logged in
/// ----------------------------------------------------------------------------
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService.currentUser;

    // Already logged in → Go Home
    if (user != null) {
      return const HomeScreen();
    }

    // Not logged in → Go Welcome screen
    return const WelcomeScreen();
  }
}
