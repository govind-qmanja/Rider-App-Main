// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_background_service/flutter_background_service.dart'
    show FlutterBackgroundService;

import 'package:permission_handler/permission_handler.dart';
import '../location_service.dart';

Future startRiderLocationService(
  String riderId,
  String printerId,
  String orderId,
  String token,
  String businessId,
) async {
  try {
    // Request required permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.location,
      Permission.locationAlways,
    ].request();

    // Ensure location permission granted
    if (!statuses[Permission.location]!.isGranted) {
      debugPrint("❌ Location permission denied.");
      return;
    }

    final service = FlutterBackgroundService();

    bool isRunning = await service.isRunning();

    debugPrint("🚀 Service running: $isRunning");

    // Start service if not already running
    if (!isRunning) {
      debugPrint("🔧 Initializing background service");

      await initializeService();

      await service.startService();

      // Small delay to ensure service fully initializes
      await Future.delayed(const Duration(seconds: 1));
    }

    // Debug logs to confirm correct values
    debugPrint("📡 Starting tracking with:");
    debugPrint("RiderId: $riderId");
    debugPrint("PrinterId: $printerId");
    debugPrint("BusinessId: $businessId");
    debugPrint("OrderId: $orderId");
    debugPrint("Token: $token");

    // Send event to background service
    service.invoke("start_tracking", {
      "riderId": riderId,
      "printerId": printerId,
      "businessId": businessId,
      "orderId": orderId,
      "token": token,
    });

    debugPrint("✅ Rider location tracking started.");
  } catch (e) {
    debugPrint("❌ Error starting rider location service: $e");
  }
}
