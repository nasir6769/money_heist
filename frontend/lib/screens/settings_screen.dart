import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = true;

  // Toggles
  bool notifications = true;
  bool autoInvest = false;
  bool privacyMode = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) return;

      final res = await SupabaseService.client
          .from('user_settings')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (res != null) {
        notifications = res['notifications'] ?? true;
        autoInvest = res['auto_invest'] ?? false;
        privacyMode = res['privacy_mode'] ?? false;
      } else {
        // Create default settings row if not exists
        await SupabaseService.client.from('user_settings').insert({
          'id': user.id,
          'notifications': true,
          'auto_invest': false,
          'privacy_mode': false,
        });
      }

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateSetting(String field, bool value) async {
    final user = SupabaseService.currentUser;

    try {
      await SupabaseService.client
          .from('user_settings')
          .update({field: value})
          .eq('id', user!.id);
    } catch (_) {}
  }

  Future<void> logout(BuildContext context) async {
    await SupabaseService.signOut();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BACK
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
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

                      // NOTIFICATIONS
                      _toggleTile(
                        icon: Icons.notifications_active,
                        iconColor: Colors.orange,
                        title: "Notifications",
                        value: notifications,
                        onChanged: (v) {
                          setState(() => notifications = v);
                          updateSetting("notifications", v);
                        },
                      ),

                      const SizedBox(height: 12),

                      // AUTO INVEST
                      _toggleTile(
                        icon: Icons.auto_graph,
                        iconColor: Colors.blue,
                        title: "Auto Investment",
                        value: autoInvest,
                        onChanged: (v) {
                          setState(() => autoInvest = v);
                          updateSetting("auto_invest", v);
                        },
                      ),

                      const SizedBox(height: 12),

                      // PRIVACY MODE
                      _toggleTile(
                        icon: Icons.visibility_off,
                        iconColor: Colors.redAccent,
                        title: "Privacy Mode",
                        value: privacyMode,
                        onChanged: (v) {
                          setState(() => privacyMode = v);
                          updateSetting("privacy_mode", v);
                        },
                      ),

                      const SizedBox(height: 25),

                      // HELP
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
                        onTap: () => logout(context),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ⭐ TOGGLE TILE
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
                  fontSize: 16, fontWeight: FontWeight.w600),
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

  // ⭐ STATIC TILE
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
