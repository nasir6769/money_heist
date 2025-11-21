import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;

  String fullName = "";
  String email = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final user = SupabaseService.currentUser;

      if (user == null) return;

      // Get email from auth
      email = user.email ?? "";

      // Fetch profile from profiles table
      final data = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) {
        fullName = data['full_name'] ?? "";
        phone = data['phone'] ?? "";
      }

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
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
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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

                      const SizedBox(height: 25),

                      // ⭐ PROFILE HEADER
                      Center(
                        child: Column(
                          children: [
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

                            Text(
                              fullName.isEmpty ? "Hello User" : "Hello, $fullName",
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

                      // ⭐ EMAIL + PHONE
                      _profileInfoTile("Email", email),
                      const SizedBox(height: 12),
                      _profileInfoTile(
                        "Phone Number",
                        phone.isNotEmpty ? phone : "Not added",
                      ),

                      const SizedBox(height: 30),

                      // ⭐ PROFILE OPTIONS
                      _profileOption(
                        icon: Icons.person_outline,
                        title: "Personal Information",
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),

                      _profileOption(
                        icon: Icons.lock_outline,
                        title: "Security",
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),

                      _profileOption(
                        icon: Icons.link,
                        title: "Linked Accounts",
                        onTap: () {},
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

  // ⭐ INFO TILE
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // ⭐ OPTION TILE
  Widget _profileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  // ⭐ LOGOUT BUTTON
  Widget _logoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => logout(context),
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
