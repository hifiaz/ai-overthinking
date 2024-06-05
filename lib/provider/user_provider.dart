import 'package:ai_overthinking/service/firebase_service.dart';
import 'package:signals/signals_flutter.dart';

class UserProvider {
  final user = FutureSignal(() => FirebaseService().user());
}

final userProvider = UserProvider();
