import 'package:flutter/material.dart';
import 'package:machine_test/data/local/token.dart';
import 'package:machine_test/feature/auth/view/login.dart';
import 'package:machine_test/feature/home/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _checkUser();
    super.initState();
  }

  void _checkUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final isLogin = await TokenHelper.hasToken();
    if (isLogin) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: FlutterLogo(size: 100)));
  }
}
