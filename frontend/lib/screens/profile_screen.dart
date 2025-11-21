import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ⭐ GET NAME PASSED FROM HOME (if needed)
    final String userName =
        ModalRoute.of(context)!.settings.arguments as String? ?? "User";

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

                const SizedBox(height: 25),

                // ⭐ PROFILE HEADER
                Center(
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person,
                            size: 70, color: Colors.white),
                      ),
                      const SizedBox(height: 20),

                      // USER NAME
                      Text(
                        "Hello, $userName",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Welcome back to MoneyHeist",
                        style: TextStyle(
                          color: Colors.green.shade300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // ⭐ EMAIL + PHONE SECTION
                _profileInfoTile("Email", "yourname@email.com"),
                const SizedBox(height: 12),
                _profileInfoTile("Phone Number", "+91 98765 43210"),

                const SizedBox(height: 30),

                // ⭐ PROFILE OPTION SECTIONS
                _profileOption(
                  icon: Icons.person_outline,
                  title: "Personal Information",
                ),
                const SizedBox(height: 12),
                _profileOption(
                  icon: Icons.lock_outline,
                  title: "Security",
                ),
                const SizedBox(height: 12),
                _profileOption(
                  icon: Icons.link,
                  title: "Linked Accounts",
                ),

                const SizedBox(height: 30),

                // ⭐ LOGOUT BUTTON
                _logoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ⭐ INFO TILE (Email, Phone)
  Widget _profileInfoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.green.shade800),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // ⭐ PROFILE OPTION TILE
  Widget _profileOption({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black45),
        ],
      ),
    );
  }

  // ⭐ LOGOUT BUTTON
  Widget _logoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
