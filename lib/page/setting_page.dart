import 'package:ai_overthinking/service/auth_service.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Settings page'),
            TextButton(
                onPressed: () => auth.logout(), child: const Text('logout')),
          ],
        ),
      ),
    );
  }
}
