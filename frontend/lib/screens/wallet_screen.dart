import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isLoading = true;
  double walletBalance = 0.0;
  double savingsBalance = 0.0;
  double totalInvested = 0.0;
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) return;

      final balance = await SupabaseService.getWalletBalance();
      final savings = await SupabaseService.getSavingsBalance();
      final txList = await SupabaseService.getTransactions();

      double invested = 0;
      for (final tx in txList) {
        if (tx['type'] == 'investment') {
          invested += (tx['amount'] as num).toDouble();
        }
      }

      setState(() {
        walletBalance = balance;
        savingsBalance = savings;
        totalInvested = invested;
        transactions = txList;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = walletBalance + savingsBalance;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001B10), Color(0xFF003314)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: loadWalletData,
            color: Colors.green,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        size: 28, color: Colors.white),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Wallet Overview",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.green.shade700,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total Balance",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 10),
                        Text(
                          "₹${totalBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Wallet: ₹${walletBalance.toStringAsFixed(2)}  |  Savings: ₹${savingsBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: _actionTile(
                          icon: Icons.arrow_downward,
                          title: "Transfer",
                          subtitle: "To bank account",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _actionTile(
                          icon: Icons.show_chart,
                          title: "Invest",
                          subtitle: "Start investing",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _summaryTile(
                            title: "Total Invested",
                            value: "₹${totalInvested.toStringAsFixed(2)}",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _summaryTile(
                            title: "Transactions",
                            value: "${transactions.length}",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Transactions",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (transactions.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                "No transactions yet",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ),
                          )
                        else
                          ...transactions.map(
                            (tx) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tx['type'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "₹${(tx['amount'] as num).toDouble().toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: (tx['type'] == 'debit')
                                          ? Colors.red
                                          : Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 26, color: Colors.blue.shade800),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          )
        ],
      ),
    );
  }

  Widget _summaryTile({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
