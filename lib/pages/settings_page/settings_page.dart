import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "Settings",
                style: TextStyle(
                    color: Color.fromARGB(255, 244, 244, 244), fontSize: 20),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.cyan[900],
      ),
    );
  }
}
