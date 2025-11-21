import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class MyInvestmentsScreen extends StatefulWidget {
  const MyInvestmentsScreen({super.key});

  @override
  State<MyInvestmentsScreen> createState() => _MyInvestmentsScreenState();
}

class _MyInvestmentsScreenState extends State<MyInvestmentsScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> investments = [];
  double totalInvested = 0.0;

  @override
  void initState() {
    super.initState();
    loadInvestments();
  }

  Future<void> loadInvestments() async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) throw "User not logged in";

      final data = await SupabaseService.client
          .from('investments')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      double sum = 0.0;
      for (var inv in data) {
        sum += (inv['amount'] ?? inv['invested_amount'] ?? 0).toDouble();
      }

      setState(() {
        investments = List<Map<String, dynamic>>.from(data);
        totalInvested = sum;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load investments: $e")),
      );
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
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "My Investments",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Total Invested: ₹${totalInvested.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      const SizedBox(height: 20),

                      Expanded(
                        child: investments.isEmpty
                            ? const Center(
                                child: Text(
                                  "No investments yet",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: investments.length,
                                itemBuilder: (context, index) {
                                  final inv = investments[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 14),
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.trending_up,
                                            color: Colors.green.shade700,
                                            size: 30),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(inv['stock_name'] ?? inv['symbol'] ?? "N/A",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  "Symbol: ${inv['stock_symbol'] ?? inv['symbol'] ?? 'N/A'}",
                                                  style: const TextStyle(
                                                      color: Colors.black54)),
                                              Text(
                                                  "Invested: ₹${((inv['amount'] ?? inv['invested_amount'] ?? 0) as num).toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                      color: Colors.black87)),
                                              if (inv['risk'] != null)
                                                Text(
                                                  "Risk: ${inv['risk']}",
                                                  style: const TextStyle(
                                                      color: Colors.black54),
                                                ),
                                              Text(
                                                "Date: ${inv['created_at'] ?? 'N/A'}",
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
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
