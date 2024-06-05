import 'package:ai_overthinking/service/firebase_service.dart';
import 'package:signals/signals_flutter.dart';

class Auth {
  final api = FirebaseService();

  /// Current user signal
  late final currentUser = api.userStream().toSignal();

  late final settings = streamSignal(
    () => api.todosStream(currentUser.value.value?.uid ?? '0'),
    dependencies: [currentUser],
  );

  /// Computed signal that only emits when the user is logged in / out
  late final isLoggedIn = computed(() => currentUser.value.value != null);

  /// Computed signal that returns the current user name or 'N/A'
  late final currentUserName = computed(
    () => currentUser.value.value?.email ?? 'N/A',
  );

  // Dispose of the stream controller
  void dispose() {
    currentUser.dispose();
  }

  /// Logout
  void logout() => api.logout();
}

final auth = Auth();
