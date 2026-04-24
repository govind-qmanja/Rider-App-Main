// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> initOneSignalWithTag(int riderId) async {
  // Set log level for debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  // Initialize OneSignal
  OneSignal.initialize('082d32e7-986c-41f0-b069-888a7933dde3');

  // Request permission to show notifications
  await OneSignal.Notifications.requestPermission(true);

  // Add tag directly using OneSignal API (v5+)
  if (riderId != 0) {
    await OneSignal.login(riderId.toString()); // optional but useful
    await OneSignal.User.addTags({"rider_Id": riderId.toString()});
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
