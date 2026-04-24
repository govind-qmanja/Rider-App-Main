import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const String API_URL =
    "https://xrx9v2z4ul.execute-api.ap-south-1.amazonaws.com/RiderLocSave";

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      initialNotificationTitle: 'Rider App',
      initialNotificationContent: 'Location tracking enabled',
      foregroundServiceNotificationId: 888,
      foregroundServiceTypes: const [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  String? currentRiderId;
  String? currentPrinterId;
  String? currentBusinessId;
  String? currentOrderId;
  String? currentToken;

  StreamSubscription<Position>? positionStream;
  Position? lastSentPosition;

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stop_tracking').listen((event) {
    // 1. Cancel the GPS stream
    positionStream?.cancel();

    // 2. Force Android to remove the persistent notification immediately
    if (service is AndroidServiceInstance) {
      service.setAsBackgroundService();
    }

    // 3. Kill the background isolate completely
    service.stopSelf();
  });

  service.on('start_tracking').listen((event) {
    if (event != null) {
      currentRiderId = event['riderId'];
      currentPrinterId = event['printerId'];
      currentBusinessId = event['businessId'];
      currentOrderId = event['orderId'];
      currentToken = event['token'];

      lastSentPosition = null;

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Order #$currentOrderId Active",
          content: "Tracking location...",
        );
      }

      positionStream?.cancel();

      positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        if (currentRiderId != null && currentToken != null) {
          bool shouldUpdate = false;

          if (lastSentPosition == null) {
            shouldUpdate = true;
          } else {
            double distance = Geolocator.distanceBetween(
              lastSentPosition!.latitude,
              lastSentPosition!.longitude,
              position.latitude,
              position.longitude,
            );

            if (distance >= 10) {
              shouldUpdate = true;
            }
          }

          if (shouldUpdate) {
            lastSentPosition = position;

            _sendLocationToApi(
              riderId: currentRiderId!,
              printerId: currentPrinterId ?? "",
              businessId: currentBusinessId ?? "",
              orderId: currentOrderId ?? "",
              token: currentToken!,
              position: position,
            );
          }
        }
      });
    }
  });
}

Future<void> _sendLocationToApi({
  required String riderId,
  required String printerId,
  required String businessId,
  required String orderId,
  required String token,
  required Position position,
}) async {
  try {
    final uri = Uri.parse(API_URL);

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "AuthorizationToken": token,
      },
      body: jsonEncode({
        "RiderId": riderId,
        "PrinterId": printerId,
        "BusinessId": businessId,
        "OrderId": orderId,
        "Lat": position.latitude.toString(),
        "Long": position.longitude.toString(),
      }),
    );

    debugPrint("STATUS: ${response.statusCode}");
    debugPrint("BODY: ${response.body}");
  } catch (e) {
    debugPrint("Network Exception: $e");
  }
}
