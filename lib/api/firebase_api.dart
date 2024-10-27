import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('${FCMToken}');
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return const SettingsPage();
    // }));
  }
}
