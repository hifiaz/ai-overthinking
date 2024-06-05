import 'dart:async';

import 'package:ai_overthinking/model/setting_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  // This uses a controller but this user stream could come from a
  // database or library like Firebase
  final _controller = StreamController<User?>();

  Stream<User?> userStream() => FirebaseAuth.instance.authStateChanges();

  Stream<List<Setting>> todosStream(String userId) {
    return Stream.value([
      (userId: userId, key: 'darkMode', value: true),
      (userId: userId, key: 'notifications', value: false),
    ]);
  }

  void login(User data) {
    _controller.add(data);
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  void dispose() {
    _controller.close();
  }
}
