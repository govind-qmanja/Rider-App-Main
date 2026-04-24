// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getGoogleMapAddress(double latitude, double longitude) async {
  try {
    const apiKey = 'AIzaSyAEGnAI1UJzKCtemyQ4Qi8DaiGQm6l3x1A'; // 🔁 Replace this
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey',
    );

    final response = await http.get(url);
    final jsonData = json.decode(response.body);

    if (jsonData['status'] == 'OK') {
      final formattedAddress = jsonData['results'][0]['formatted_address'];
      return formattedAddress;
    } else {
      return 'No address found';
    }
  } catch (e) {
    return 'Error: $e';
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
