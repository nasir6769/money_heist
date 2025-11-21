import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  Future<void> addMoneyToWallet() async {
    String input = amountController.text.trim();

    // Basic validation: empty or non-numeric
    if (input.isEmpty || double.tryParse(input) == null) {
      _showMsg("Enter a valid amount");
      return;
    }

    double amount = double.parse(input);

    // No negative or zero
    if (amount <= 0) {
      _showMsg("Amount must be greater than 0");
      return;
    }

    // Limit (example: ₹1,00,000 per add)
    if (amount > 100000) {
      _showMsg("Maximum limit is ₹1,00,000 at once");
      return;
    }

    setState(() => isLoading = true);

    try {
      await SupabaseService.addMoney(amount);

      if (!mounted) return;

      setState(() => isLoading = false);

      _showMsg("₹${amount.toStringAsFixed(2)} added successfully!");

      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);
      _showMsg("Failed: $e");
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isLoading, // Prevent back during loading
      child: Scaffold(
        backgroundColor: const Color(0xFF001B10),
        appBar: AppBar(
          title: const Text("Add Money"),
          backgroundColor: Colors.green.shade600,
          automaticallyImplyLeading: !isLoading,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ADD MONEY BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addMoneyToWallet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Add Money",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
