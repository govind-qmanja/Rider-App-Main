// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getFCMToken() async {
  // Add your function code here!
  try {
    // Request permission (required for token generation on some platforms)
    await FirebaseMessaging.instance.requestPermission();

    // Fetch the token
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint("🔥 ACTUAL FCM TOKEN: $token");
    // Return token or empty string if null
    return token ?? "";
  } catch (e) {
    return "";
  }
}
