import 'package:flutter/material.dart';
import 'package:machine_test/data/local/token.dart';
import 'package:machine_test/feature/home/widget/student_table.dart';

import '../../auth/view/login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 130,
            padding: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/banner.png"),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Student Listing',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.22),
                IconButton(
                  onPressed: () async {
                    await TokenHelper.clearToken();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                ),
              ],
            ),
          ),
          const Expanded(child: StudentTableScreen()),
        ],
      ),
    );
  }
}
