// STEP 4: Add Investment Prompt when savings >= 1000

import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class MyBalanceScreen extends StatefulWidget {
  const MyBalanceScreen({super.key});

  @override
  State<MyBalanceScreen> createState() => _MyBalanceScreenState();
}

class _MyBalanceScreenState extends State<MyBalanceScreen> {
  double walletBalance = 0;
  double savingsBalance = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBalances();
  }

  Future<void> loadBalances() async {
    try {
      final wallet = await SupabaseService.getWalletBalance();
      final savings = await SupabaseService.getSavingsBalance();

      setState(() {
        walletBalance = wallet;
        savingsBalance = savings;
        isLoading = false;
      });

      // ⭐ Step 4: Check for investment prompt
      if (savings >= 1000) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) showInvestmentPopup();
        });
      }
    } catch (e) {
      print('Error loading balances: $e');
      setState(() => isLoading = false);
    }
  }

  void showInvestmentPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Invest Your Savings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You have saved ₹${savingsBalance.toStringAsFixed(2)}!\n\nWould you like to invest this amount in the stock market?',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/stocks');
            },
            child: const Text('Invest Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001B10), Color(0xFF003314)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Balance',
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      _balanceCard('Wallet Balance', walletBalance, Colors.green),
                      const SizedBox(height: 16),
                      _balanceCard('Auto Savings', savingsBalance, Colors.blue),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _balanceCard(String title, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('₹${value.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
