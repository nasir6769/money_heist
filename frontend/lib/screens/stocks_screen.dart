import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/investment_service.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  String selectedPreference = "Short-Term";
  double availableBalance = 0;
  List<Map<String, dynamic>> suggestions = [];
  bool isInvesting = false;

  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    try {
      final savings = await SupabaseService.getSavingsBalance();
      setState(() {
        availableBalance = savings;
        suggestions = InvestmentService.getStockSuggestions(selectedPreference, savings);
      });
    } catch (e) {
      debugPrint("Error loading wallet: $e");
    }
  }

  void refreshSuggestions() {
    setState(() {
      suggestions = InvestmentService.getStockSuggestions(selectedPreference, availableBalance);
    });
  }

  Future<void> investInStock(Map<String, dynamic> stock) async {
    if (availableBalance < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Insufficient balance to invest.")),
      );
      return;
    }

    final investAmount = availableBalance * 0.1; // invest 10% of savings
    setState(() => isInvesting = true);

    try {
      final user = SupabaseService.currentUser;
      if (user == null) throw "User not logged in";

      // 1️⃣ Insert into investments table
      await SupabaseService.client.from('investments').insert({
        'user_id': user.id,
        'symbol': stock['symbol'],
        'amount': investAmount,
        'risk': stock['risk'],
      });

      // 2️⃣ Deduct from savings wallet
      await SupabaseService.client
          .from('savings_wallet')
          .update({'balance': availableBalance - investAmount})
          .eq('user_id', user.id);

      // 3️⃣ Update local state
      setState(() {
        availableBalance -= investAmount;
        isInvesting = false;
      });

      // 4️⃣ Show success popup
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Investment Successful"),
          content: Text(
              "Invested ₹${investAmount.toStringAsFixed(2)} in ${stock['symbol']}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      debugPrint("Investment failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Investment failed: $e")),
      );
    } finally {
      setState(() => isInvesting = false);
    }
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Investment Suggestions",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),

                Text(
                  "Savings: ₹${availableBalance.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: selectedPreference,
                    underline: const SizedBox(),
                    isExpanded: true,
                    items: ["Short-Term", "Long-Term", "Balanced"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      setState(() => selectedPreference = v!);
                      refreshSuggestions();
                    },
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: suggestions.isEmpty
                      ? const Center(
                          child: Text(
                            "No suggestions available",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          itemCount: suggestions.length,
                          itemBuilder: (context, index) {
                            final s = suggestions[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.trending_up, color: Colors.green.shade700, size: 30),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(s["name"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Text("Symbol: ${s["symbol"]}", style: const TextStyle(color: Colors.black54)),
                                        Text("Growth: ${s["growth"]}", style: const TextStyle(color: Colors.black54)),
                                        Text("Risk: ${s["risk"]}", style: const TextStyle(color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: isInvesting
                                        ? null
                                        : () => investInStock(s),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade700,
                                    ),
                                    child: isInvesting
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                          )
                                        : const Text("Invest"),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
