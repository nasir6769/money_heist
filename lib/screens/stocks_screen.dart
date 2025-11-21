import 'package:flutter/material.dart';

class StocksScreen extends StatelessWidget {
  const StocksScreen({super.key});

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

                // TITLE
                const Text(
                  "Stock Investment",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Choose your investment preference",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade300,
                  ),
                ),

                const SizedBox(height: 40),

                // SHORT TERM CARD
                _stockOptionCard(
                  title: "Short-Term",
                  description: "Low risk • 1-3 months • Quick returns",
                  icon: Icons.trending_up,
                  iconColor: Colors.blue,
                  onTap: () {
                    // Later can navigate to details
                  },
                ),

                const SizedBox(height: 20),

                // LONG TERM CARD
                _stockOptionCard(
                  title: "Long-Term",
                  description: "Minimal risk • 1-3 years • Good growth",
                  icon: Icons.show_chart,
                  iconColor: Colors.orange,
                  onTap: () {
                    // Later can navigate to details
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // STOCK OPTION CARD WIDGET
  Widget _stockOptionCard({
    required String title,
    required String description,
    required IconData icon,
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 30),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, size: 26, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}
