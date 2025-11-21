import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  double balance = 0.0;
  String userName = "User";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadUserData();
    checkAutoInvestAlert();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadUserData();
      checkAutoInvestAlert();
    }
  }

  Future<void> loadUserData() async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) return;

      final fetchedBalance = await SupabaseService.getWalletBalance();
      final profile = await SupabaseService.client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .single();

      setState(() {
        balance = fetchedBalance;
        userName = (profile['full_name'] ?? "User").toString();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to load data: $e")));
    }
  }

  Future<void> checkAutoInvestAlert() async {
    try {
      final savings = await SupabaseService.getSavingsBalance();

      if (savings >= 1000) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Investment Opportunity 💰",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              "You’ve saved ₹1000+ in your wallet!\nWould you like to invest it now?",
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text("Not Now", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/stocks');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                ),
                child: const Text("Invest Now"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint("Auto-invest check failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001B10),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadUserData,
          color: Colors.green,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👋 HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, $userName!",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Welcome to MoneyHeist",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green.shade300,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 💳 BALANCE CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.green.shade600,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Balance",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                        isLoading
                            ? "Loading..."
                            : "₹${balance.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Pending Investment\n₹0.00",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.white70)),
                          Text("Available\n₹${balance.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.pushNamed(context, '/addmoney');
                            loadUserData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Add Money",
                              style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 💡 FEATURES GRID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _featureCard(
                      title: "UPI Payment",
                      icon: Icons.qr_code_scanner,
                      color: Colors.blue,
                      onTap: () => Navigator.pushNamed(context, '/upi'),
                    ),
                    _featureCard(
                      title: "Stocks",
                      icon: Icons.show_chart,
                      color: Colors.orange,
                      onTap: () => Navigator.pushNamed(context, '/stocks'),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _featureCard(
                      title: "Wallet",
                      icon: Icons.account_balance_wallet,
                      color: Colors.purple,
                      onTap: () => Navigator.pushNamed(context, '/wallet'),
                    ),
                    _featureCard(
                      title: "My Balance",
                      icon: Icons.account_balance,
                      color: Colors.green,
                      onTap: () => Navigator.pushNamed(context, '/mybalance'),
                    ),
                  ],
                ),

                // 🌟 NEW SECTION: INVESTMENTS + SAVINGS
                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _featureCard(
                      title: "My Investments",
                      icon: Icons.trending_up,
                      color: Colors.amber,
                      onTap: () =>
                          Navigator.pushNamed(context, '/myinvestments'),
                    ),
                    _featureCard(
                      title: "Savings Wallet",
                      icon: Icons.savings,
                      color: Colors.teal,
                      onTap: () => Navigator.pushNamed(context, '/wallet'),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 📊 QUICK STATS
                const Text("Quick Stats",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _statRow("Auto-Investment Rate", "1–10%"),
                      const SizedBox(height: 14),
                      _statRow("Stock Preference", "Short-Term"),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🌟 Helper Widgets
Widget _featureCard({
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 12),
          Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
}

Widget _statRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label,
          style: const TextStyle(color: Colors.black87, fontSize: 15)),
      Text(value,
          style:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
    ],
  );
}
