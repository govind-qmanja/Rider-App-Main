// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_background_service/flutter_background_service.dart';

Future stopRiderLocationService() async {
  // Add your function code here!
  final service = FlutterBackgroundService();

  // This triggers the 'stop_tracking' listener in the background
  // which cancels the GPS stream and calls service.stopSelf()
  service.invoke("stop_tracking");
}
