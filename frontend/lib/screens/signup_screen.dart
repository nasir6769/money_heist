import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    // Basic validation
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      _showMsg("Please fill all fields");
      return;
    }

    if (!email.contains("@")) {
      _showMsg("Enter a valid email");
      return;
    }

    if (password.length < 6) {
      _showMsg("Password must be at least 6 characters");
      return;
    }

    try {
      setState(() => isLoading = true);

      // Create user in Supabase Auth
      final res = await SupabaseService.signUp(email, password);

      // Sometimes Supabase returns user, sometimes only session
      final newUser = res.user ?? res.session?.user;

      // If newUser is null → Email confirmation required
      if (newUser == null) {
        setState(() => isLoading = false);
        _showMsg(
            "Account created! Check your email to confirm before logging in.");
        return;
      }

      // Update profile table
      await SupabaseService.updateProfile(
        newUser.id,
        name: name,
        phone: phone,
      );

      // Create wallet entry
      await SupabaseService.createWallet(newUser.id);

      setState(() => isLoading = false);

      // Navigate to biometric
      Navigator.pushNamed(
        context,
        '/biometric',
        arguments: name,
      );
    } catch (e) {
      setState(() => isLoading = false);
      _showMsg("Signup failed: $e");
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001B10), Color(0xFF003314)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Start your smart payment journey",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _inputField(
                    controller: nameController,
                    icon: Icons.person,
                    hint: "Full Name",
                  ),
                  const SizedBox(height: 15),

                  _inputField(
                    controller: emailController,
                    icon: Icons.email_outlined,
                    hint: "Email",
                  ),
                  const SizedBox(height: 15),

                  _inputField(
                    controller: phoneController,
                    icon: Icons.phone,
                    hint: "Mobile Number",
                  ),
                  const SizedBox(height: 15),

                  _inputField(
                    controller: passwordController,
                    icon: Icons.lock_outline,
                    hint: "Password",
                    isPassword: true,
                  ),

                  const SizedBox(height: 30),

                  // Create Account Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : createAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Create Account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ",
                          style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.grey.shade700),
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
}
