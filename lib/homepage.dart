import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();

    // Check if the device supports biometrics
    auth.isDeviceSupported().then(
      (bool isSupported) {
        setState(() {
          _supportState = isSupported;
        });
        if (isSupported) {
          _authenticate(); // Trigger authentication when the app opens
        }
      },
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Please authenticate to continue",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (!authenticated) {
        // If the user fails to authenticate, you can exit the app or handle it appropriately
        SystemNavigator.pop(); // Exit the app
      }
    } on PlatformException catch (e) {
      print("Authentication error: $e");
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    print("List of Available Biometrics: $availableBiometrics");

    if (!mounted) {
      return;
    }

    // Handle the result as needed (e.g., update UI or show a dialog).
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Biometric Authentication"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_supportState)
              const Text("Device Is Supported")
            else
              const Text("Device Is Not Supported"),
            const Divider(height: 100, color: Colors.white,),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text("Authenticate"),
            ),
          ],
        ),
      ),
    );
  }
}
