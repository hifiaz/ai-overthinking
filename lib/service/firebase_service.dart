import 'dart:async';

import 'package:ai_overthinking/model/content_model.dart';
import 'package:ai_overthinking/model/setting_model.dart';
import 'package:ai_overthinking/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseFirestore service = FirebaseFirestore.instance;
  // This uses a controller but this user stream could come from a
  // database or library like Firebase
  Stream<User?> userStream() => FirebaseAuth.instance.authStateChanges();

  Stream<List<Setting>> todosStream(String userId) {
    return Stream.value([
      (userId: userId, key: 'darkMode', value: true),
      (userId: userId, key: 'notifications', value: false),
    ]);
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> createUser({
    String? email,
    String? fullName,
    int? quota,
  }) async {
    CollectionReference user = service.collection('users');
    return await user.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'email': email,
      'full_name': fullName,
      'quota': quota,
    });
  }

  Future<UserModel?> user() async {
    CollectionReference user = service.collection('users');
    final res = await user.doc(FirebaseAuth.instance.currentUser!.uid).get();

    return UserModel.fromFirestore(res.data() as Map<String, dynamic>);
  }

  Future<DocumentReference?> createContent(ContentModel content) async {
    CollectionReference contentColection = service
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('content');
    return await contentColection.add(content.toJson());
  }

  Future<List<ContentModel>?> contents() async {
    CollectionReference contentCollection = service
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('content');
    final res =
        await contentCollection.orderBy('createdAt', descending: true).get();

    return res.docs
        .map((doc) =>
            ContentModel.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
