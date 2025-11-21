import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  bool isAuthenticating = false;
  bool isSuccess = false;

  Future<void> authenticateUser(String userName) async {
    try {
      setState(() {
        isAuthenticating = true;
      });

      // Slight delay for smooth UX
      await Future.delayed(const Duration(milliseconds: 500));

      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate to continue",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        // Show success UI
        setState(() {
          isSuccess = true;
          isAuthenticating = false;
        });

        // Wait 2 seconds → then go to home
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: userName,
        );
      } else {
        setState(() {
          isAuthenticating = false;
        });
      }
    } catch (e) {
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ GET THE NAME PASSED FROM SIGNUP
    final String userName =
        ModalRoute.of(context)!.settings.arguments as String? ?? "User";

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001B10), Color(0xFF003314)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: isSuccess
                  ? successUI()
                  : isAuthenticating
                      ? authenticatingUI()
                      : mainUI(userName),
            ),
          ),
        ),
      ),
    );
  }

  // MAIN UI (Figma Screen 1)
  Widget mainUI(String userName) {
    return Column(
      key: const ValueKey(1),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.fingerprint,
            size: 80,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 30),

        const Text(
          "Biometric Authentication",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Touch the fingerprint sensor to continue",
          style: TextStyle(
            fontSize: 14,
            color: Colors.green.shade300,
          ),
        ),

        const SizedBox(height: 50),

        SizedBox(
          width: 260,
          child: ElevatedButton(
            onPressed: () => authenticateUser(userName),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade500,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Authenticate with Fingerprint",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 15),

        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/home',
              arguments: userName,
            );
          },
          child: const Text(
            "Skip for Now",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  // AUTHENTICATING UI (Figma Screen 2)
  Widget authenticatingUI() {
    return Column(
      key: const ValueKey(2),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.fingerprint,
            size: 80,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 30),

        const Text(
          "Biometric Authentication",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Authenticating...",
          style: TextStyle(color: Colors.green.shade300),
        ),

        const SizedBox(height: 25),

        const CircularProgressIndicator(
          color: Colors.white,
        ),
      ],
    );
  }

  // SUCCESS UI (Figma Screen 3)
  Widget successUI() {
    return Column(
      key: const ValueKey(3),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: const BoxDecoration(
            color: Color(0xFF0A7A3E),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 80,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "Authentication Successful!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
