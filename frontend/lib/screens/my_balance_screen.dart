import 'package:flutter/material.dart';

class MyBalanceScreen extends StatelessWidget {
  const MyBalanceScreen({super.key});

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
          child: SingleChildScrollView(
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
                  "My Balance",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                // ⭐ MAIN BALANCE CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Available Balance",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "₹10,000.00",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Funds available for UPI payments & investments",
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ⭐ STATS CARDS (UPI total + Auto-invest)
                Row(
                  children: [
                    Expanded(
                      child: _smallStatCard(
                        title: "UPI Payments",
                        value: "₹15,000",
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _smallStatCard(
                        title: "Auto-Invested",
                        value: "₹2,500",
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ⭐ HISTORY TITLE
                const Text(
                  "Recent Activity",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 14),

                // ⭐ HISTORY BOX
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "No recent activity",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ⭐ CATEGORY TITLE
                const Text(
                  "Expense Categories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // ⭐ CATEGORY CARDS (like Figma)
                Row(
                  children: [
                    Expanded(
                      child: _categoryCard(
                        color: Colors.green,
                        icon: Icons.fastfood,
                        title: "Food",
                        amount: "₹4,500",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _categoryCard(
                        color: Colors.blue,
                        icon: Icons.flight_takeoff,
                        title: "Travel",
                        amount: "₹2,000",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _categoryCard(
                        color: Colors.purple,
                        icon: Icons.receipt_long,
                        title: "Bills",
                        amount: "₹1,200",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _categoryCard(
                        color: Colors.orange,
                        icon: Icons.shopping_bag,
                        title: "Shopping",
                        amount: "₹3,000",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ⭐ SMALL STATS CARD WIDGET
  Widget _smallStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  // ⭐ CATEGORY CARD WIDGET
  Widget _categoryCard({
    required Color color,
    required IconData icon,
    required String title,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
