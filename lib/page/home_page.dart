import 'dart:developer';

import 'package:ai_overthinking/provider/content_provider.dart';
import 'package:ai_overthinking/provider/purchase_provider.dart';
import 'package:ai_overthinking/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final subscribe = subscriptionProvider.isActive.watch(context);
    final content = contentProvider.contentFromFirebase.watch(context);
    contentProvider.contentComputed.watch(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () async {
                final paywallResult = await RevenueCatUI.presentPaywall();
                log('Paywall result: $paywallResult');
              },
              child:
                  Text(subscribe.value ?? false ? 'Subscribed' : 'Subscribe')),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/robot.png', height: 230),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Ai Overthinking',
                    style: ShadTheme.of(context).textTheme.h2,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/ask'),
                        child: ShadCard(
                          title: const ShadAvatar(
                            'assets/overthink.png',
                            backgroundColor: Colors.blue,
                            size: Size(120, 120),
                            placeholder: Text('CN'),
                          ),
                          description: Text(
                            'Overthink? ->',
                            style: ShadTheme.of(context).textTheme.h4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/settings'),
                        child: ShadCard(
                          title: const ShadAvatar(
                            'assets/settings.png',
                            backgroundColor: Colors.blue,
                            size: Size(120, 120),
                            placeholder: Text('CN'),
                          ),
                          description: Text('Settings ->',
                              style: ShadTheme.of(context).textTheme.h4),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    'History Questions',
                    style: ShadTheme.of(context).textTheme.h4,
                  ),
                ),
                content.map(
                  data: (val) {
                    if (val == null) {
                      return const Text('No content found');
                    }
                    return Column(
                      children: val
                          .where((element) => element.fromUser)
                          .map(
                            (item) => Container(
                              padding: const EdgeInsets.all(15),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.electric_bolt,
                                    color: Colors.yellow[800],
                                  ),
                                  const SizedBox(width: 8),
                                  Text((item.text ?? 'No text'),
                                      style: ShadTheme.of(context).textTheme.p)
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                  error: (err) => Text('Something went wrong $err'),
                  loading: () => const Text('Loading...'),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
                left: 20.0,
                right: 20.0,
              ),
              child: ShadButton(
                width: double.infinity,
                onPressed: () => context.push('/ask'),
                icon: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.add,
                    size: 16,
                  ),
                ),
                child: const Text('Ask'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
