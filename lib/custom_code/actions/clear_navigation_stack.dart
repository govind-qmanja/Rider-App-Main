// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future clearNavigationStack(BuildContext context) async {
  // This removes all screens/dialogs until only the first route (root) is left
  Navigator.of(context).popUntil((route) => route.isFirst);
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
