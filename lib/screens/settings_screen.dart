import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Toggles
  bool notifications = true;
  bool autoInvest = false;
  bool privacyMode = false;

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
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                // ⭐ NOTIFICATION TOGGLE
                _toggleTile(
                  icon: Icons.notifications_active,
                  iconColor: Colors.orange,
                  title: "Notifications",
                  value: notifications,
                  onChanged: (v) => setState(() => notifications = v),
                ),

                const SizedBox(height: 12),

                // ⭐ AUTO INVESTMENT TOGGLE
                _toggleTile(
                  icon: Icons.auto_graph,
                  iconColor: Colors.blue,
                  title: "Auto Investment",
                  value: autoInvest,
                  onChanged: (v) => setState(() => autoInvest = v),
                ),

                const SizedBox(height: 12),

                // ⭐ PRIVACY MODE TOGGLE
                _toggleTile(
                  icon: Icons.visibility_off,
                  iconColor: Colors.redAccent,
                  title: "Privacy Mode",
                  value: privacyMode,
                  onChanged: (v) => setState(() => privacyMode = v),
                ),

                const SizedBox(height: 25),

                // ⭐ STATIC OPTIONS
                _staticTile(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  onTap: () {},
                ),

                const SizedBox(height: 12),

                _staticTile(
                  icon: Icons.description_outlined,
                  title: "Terms & Conditions",
                  onTap: () {},
                ),

                const SizedBox(height: 12),

                _staticTile(
                  icon: Icons.logout,
                  title: "Logout",
                  titleColor: Colors.redAccent,
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ⭐ TOGGLE TILE WIDGET
  Widget _toggleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            activeColor: iconColor,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }

  // ⭐ STATIC TILE WIDGET
  Widget _staticTile({
    required IconData icon,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ?? Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
