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
  bool hasBiometrics = true;

  @override
  void initState() {
    super.initState();
    checkBiometricSupport();
  }

  Future<void> checkBiometricSupport() async {
    try {
      bool canCheck = await auth.canCheckBiometrics;
      List<BiometricType> types = await auth.getAvailableBiometrics();

      if (!canCheck || types.isEmpty) {
        setState(() => hasBiometrics = false);
      }
    } catch (e) {
      setState(() => hasBiometrics = false);
    }
  }

  Future<void> authenticateUser() async {
    try {
      setState(() => isAuthenticating = true);

      await Future.delayed(const Duration(milliseconds: 500));

      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate to continue",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (authenticated) {
        setState(() {
          isSuccess = true;
          isAuthenticating = false;
        });

        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() => isAuthenticating = false);
      }
    } catch (e) {
      setState(() => isAuthenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      : hasBiometrics
                          ? mainUI()
                          : fallbackUI(), // ⭐ No biometrics → show fallback
            ),
          ),
        ),
      ),
    );
  }

  // MAIN UI
  Widget mainUI() {
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
            onPressed: authenticateUser,
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
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: const Text(
            "Skip for Now",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  // UI when biometrics not available
  Widget fallbackUI() {
    return Column(
      key: const ValueKey(4),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.white),
        const SizedBox(height: 20),
        const Text(
          "No Biometric Support",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Your device does not support fingerprint/face unlock.",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade500,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
          ),
          child: const Text("Continue to App"),
        ),
      ],
    );
  }

  // AUTHENTICATING UI
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
          "Authenticating...",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 25),
        const CircularProgressIndicator(color: Colors.white),
      ],
    );
  }

  // SUCCESS UI
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
