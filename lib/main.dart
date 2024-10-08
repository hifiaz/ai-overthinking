import 'package:ai_overthinking/firebase_options.dart';
import 'package:ai_overthinking/service/router_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

final isPurcaseActive = Signal(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setPathUrlStrategy();
  initPlatformState();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.materialRouter(
      debugShowCheckedModeBanner: false,
      title: 'Ai Overthinking',
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
    );
  }
}

Future<void> initPlatformState() async {
  await Purchases.setLogLevel(LogLevel.debug);

  PurchasesConfiguration configuration =
      PurchasesConfiguration('goog_dpBlcqpcZvlbqsckqGsMAHWYYpN');

  // else if (Platform.isIOS) {
  //   configuration = PurchasesConfiguration(<revenuecat_project_apple_api_key>);
  // }
  await Purchases.configure(configuration);
}
