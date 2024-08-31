import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:signals/signals_flutter.dart';

class SubscriptionProvider {
  final isActive = futureSignal<bool>(() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.activeSubscriptions.isNotEmpty == true;
    } catch (e) {
      return false;
    }
  }, autoDispose: true);
}

final subscriptionProvider = SubscriptionProvider();
