// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> initOneSignal() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('082d32e7-986c-41f0-b069-888a7933dde3');

  OneSignal.Notifications.requestPermission(true);

  // Optional: Add tag/userID if needed
  // OneSignal.User.addTag("user_id", "123");
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
