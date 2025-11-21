import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class UpiPaymentScreen extends StatefulWidget {
  const UpiPaymentScreen({super.key});

  @override
  State<UpiPaymentScreen> createState() => _UpiPaymentScreenState();
}

class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
  final TextEditingController amountController = TextEditingController();
  bool isPaying = false;
  double walletBalance = 0;

  final List<String> categories = [
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Entertainment",
    "General"
  ];
  String selectedCategory = "General";

  @override
  void initState() {
    super.initState();
    loadWalletBalance();
  }

  Future<void> loadWalletBalance() async {
    try {
      final balance = await SupabaseService.getWalletBalance();
      setState(() => walletBalance = balance);
    } catch (_) {}
  }

  Future<void> makePayment() async {
    final rawAmount = amountController.text.trim();
    final amount = double.tryParse(rawAmount);

    if (amount == null || amount <= 0) {
      _showMsg("Enter a valid amount");
      return;
    }

    if (amount > 25000) {
      _showMsg("Maximum UPI payment allowed is ₹25,000");
      return;
    }

    if (amount > walletBalance) {
      _showMsg("Insufficient balance (₹${walletBalance.toStringAsFixed(2)})");
      return;
    }

    try {
      setState(() => isPaying = true);

      final result =
          await SupabaseService.processPayment(amount, selectedCategory);

      final newBalance = result['new_balance'];
      final newSavings = result['new_savings'];
      final savedAmount = result['saved_amount'];

      setState(() {
        walletBalance = newBalance;
        isPaying = false;
      });

      _showMsg(
        "Payment Successful!\nSaved ₹${savedAmount.toStringAsFixed(2)} to Savings\nNew Balance: ₹${newBalance.toStringAsFixed(2)}",
      );

      Navigator.pop(context, newBalance);
    } catch (e) {
      _showMsg("Payment failed: ${e.toString()}");
    } finally {
      if (mounted) setState(() => isPaying = false);
    }
  }

  void _showMsg(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                      "UPI Payment",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Pay securely using your wallet balance",
                      style: TextStyle(
                          color: Colors.green.shade300, fontSize: 14),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Wallet Balance: ₹${walletBalance.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: amountController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter amount (₹)",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      dropdownColor: Colors.white,
                      items: categories
                          .map((cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedCategory = value!),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isPaying ? null : makePayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isPaying
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Pay Now",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _paymentOption(
                      icon: Icons.qr_code_scanner,
                      title: "Scan QR Code",
                      subtitle: "Scan merchant QR to pay",
                      iconColor: Colors.blue.shade700,
                      onTap: () => Navigator.pushNamed(context, '/scan-qr'),
                    ),
                    const SizedBox(height: 20),
                    _paymentOption(
                      icon: Icons.phone_android,
                      title: "Pay by Phone Number",
                      subtitle: "Enter mobile number to pay",
                      iconColor: Colors.green.shade700,
                      onTap: () =>
                          Navigator.pushNamed(context, '/pay-phone'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 30, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
