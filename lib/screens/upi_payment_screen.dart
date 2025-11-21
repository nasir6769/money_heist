import 'package:flutter/material.dart';

class UpiPaymentScreen extends StatelessWidget {
  const UpiPaymentScreen({super.key});

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
                // BACK BUTTON
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
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
                  "Choose payment method",
                  style: TextStyle(color: Colors.green.shade300, fontSize: 14),
                ),

                const SizedBox(height: 40),

                // SCAN QR CARD
                _paymentOption(
                  icon: Icons.qr_code_scanner,
                  title: "Scan QR Code",
                  subtitle: "Scan merchant QR code to pay",
                  iconColor: Colors.blue.shade700,
                  onTap: () => Navigator.pushNamed(context, '/scan-qr'),
                ),

                const SizedBox(height: 20),

                // PAY BY PHONE
                _paymentOption(
                  icon: Icons.phone_android,
                  title: "Pay by Phone Number",
                  subtitle: "Enter phone number to pay",
                  iconColor: Colors.green.shade700,
                  onTap: () => Navigator.pushNamed(context, '/pay-phone'),
                ),
              ],
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
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
