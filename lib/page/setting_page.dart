import 'package:ai_overthinking/provider/user_provider.dart';
import 'package:ai_overthinking/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        actions: [
          IconButton(
            onPressed: () async {
              userProvider.user.refresh();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            TextButton(
                onPressed: () async {
                  final Uri params = Uri(
                    scheme: 'mailto',
                    path: 'fiazhari@gmail.com',
                    query:
                        'subject=App Feedback&body=Ai Overthinking', //add subject and body here
                  );
                  var url = params.toString();
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch';
                  }
                },
                child: const Text('Any Feedback? click to contact me 💬')),
            const Spacer(),
            TextButton(
                onPressed: () => auth.logout(),
                child: const Text(
                  'logout',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }
}
