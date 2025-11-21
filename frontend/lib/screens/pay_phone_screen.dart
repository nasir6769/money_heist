import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class PayPhoneScreen extends StatefulWidget {
  const PayPhoneScreen({super.key});

  @override
  State<PayPhoneScreen> createState() => _PayPhoneScreenState();
}

class _PayPhoneScreenState extends State<PayPhoneScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool isPaying = false;
  double walletBalance = 0;

  @override
  void initState() {
    super.initState();
    loadWalletBalance();
  }

  Future<void> loadWalletBalance() async {
    try {
      final bal = await SupabaseService.getWalletBalance();
      setState(() => walletBalance = bal);
    } catch (_) {}
  }

  Future<void> makePhonePayment() async {
    final phone = phoneController.text.trim();
    final raw = amountController.text.trim();
    final amount = double.tryParse(raw);

    // ---------------- VALIDATION ----------------

    if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      _showMsg("Enter a valid 10-digit phone number");
      return;
    }

    if (amount == null || amount <= 0) {
      _showMsg("Enter a valid amount");
      return;
    }

    if (amount > 20000) {
      _showMsg("Maximum phone payment allowed is ₹20,000");
      return;
    }

    if (amount > walletBalance) {
      _showMsg(
          "Insufficient balance. You have only ₹${walletBalance.toStringAsFixed(2)}");
      return;
    }

    // ---------------- PROCESS PAYMENT ----------------

    try {
      setState(() => isPaying = true);

      final result = await SupabaseService.processPayment(amount, "Phone Payment");

      final newBalance = result['new_balance'] ?? 0.0;
      final savedAmount = result['saved_amount'] ?? 0.0;
      final newSavings = result['new_savings'] ?? 0.0;

      if (!mounted) return;
      setState(() => isPaying = false);

      // ✅ Show popup with savings info
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Transaction Successful!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("You spent ₹${amount.toStringAsFixed(2)}"),
              const SizedBox(height: 8),
              Text(
                "₹${savedAmount.toStringAsFixed(2)} auto-saved to your savings wallet!",
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text("New Savings Balance: ₹${newSavings.toStringAsFixed(2)}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(color: Colors.green)),
            )
          ],
        ),
      );

      _showMsg("Successfully sent ₹$amount to $phone!");
      Navigator.pop(context, newBalance);
    } catch (e) {
      setState(() => isPaying = false);
      _showMsg("Payment failed. Please try again.");
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isPaying,
      child: Scaffold(
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
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Pay by Phone",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Send money using phone number",
                    style: TextStyle(fontSize: 14, color: Colors.green.shade300),
                  ),

                  const SizedBox(height: 30),

                  _inputField(
                    "Phone Number",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  _inputField(
                    "Amount (₹)",
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isPaying ? null : makePhonePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isPaying
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Proceed to Pay",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String hint, {
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
}