// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getFCMToken() async {
  // Add your function code here!
  try {
    // Request permission (required for token generation on some platforms)
    await FirebaseMessaging.instance.requestPermission();

    // iOS REQUIRES a valid APNs token before FCM can generate its own token.
    // Without this step, getToken() silently returns null on iOS.
    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

      if (apnsToken == null) {
        // APNs handshake may not be complete yet — wait and retry.
        // This is a known timing issue on iOS where the APNs token
        // arrives asynchronously after app launch.
        debugPrint('[getFCMToken] APNs token is null, waiting 3s and retrying...');
        await Future.delayed(const Duration(seconds: 3));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      }

      if (apnsToken == null) {
        // Second retry after a longer wait
        debugPrint('[getFCMToken] APNs token still null, waiting 5s for final retry...');
        await Future.delayed(const Duration(seconds: 5));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      }

      if (apnsToken == null) {
        debugPrint('[getFCMToken] ❌ APNs token is null after retries. '
            'Check: 1) aps-environment entitlement in Runner.entitlements, '
            '2) Push Notifications capability in Xcode, '
            '3) Valid APNs certificate/key in Firebase Console.');
        return "";
      }

      debugPrint('[getFCMToken] ✅ APNs token received: ${apnsToken.substring(0, 10)}...');
    }

    // Fetch the FCM token (now safe on iOS since APNs token is available)
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint("🔥 ACTUAL FCM TOKEN: $token");
    // Return token or empty string if null
    return token ?? "";
  } catch (e) {
    debugPrint('[getFCMToken] ❌ Error getting FCM token: $e');
    return "";
  }
}
