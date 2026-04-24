
import 'lat_lng.dart';
import '/backend/backend.dart';

bool? isLengthTen(String? input) {
  if (input == null) return false;

  try {
    int number = int.parse(input); // Convert string to int ✅
    String numAsString = number.toString(); // Convert back to string ✅
    return numAsString.length == 10;
  } catch (e) {
    return false; // Agar input numeric nahi hai
  }
}

bool? otpLength(String? input) {
  if (input == null) return false;

  try {
    int number = int.parse(input); // Convert string to int ✅
    String numAsString = number.toString(); // Convert back to string ✅
    return numAsString.length == 4;
  } catch (e) {
    return false; // Agar input numeric nahi hai
  }
}

DateTime? convertStringToDateTime(String dateString) {
  final parsedDate = DateTime.parse(dateString);
  // Add 5 hours 30 minutes to convert from UTC to IST
  return parsedDate.toUtc().add(const Duration(hours: 5, minutes: 30));
}

LatLng getPostalCodetoLatLng(String postalCode) {
  try {
    final parts = postalCode.split('|');
    final lat = double.parse(parts[0].trim());
    final lng = double.parse(parts[1].trim());
    return LatLng(lat, lng);
  } catch (e) {
    throw Exception('Invalid postal code format. Use "lat|lng" format.');
  }
}

List<double> getLatLong(String postalCode) {
  List<String> parts = postalCode.split("|");

  // Convert to double (latitude at index 0, longitude at index 1)

  double lat = double.parse(parts[0]);

  double lng = double.parse(parts[1]);

  return [lat, lng];
}

bool? is24HoursPassed(DateTime? pastDate) {
  if (pastDate == null) {
    return false;
  }

  final now = DateTime.now(); // Current time
  final diff = now.difference(pastDate); // Difference between now & past date

  return diff.inHours >= 24; // true if >= 24 hours
}

List<double> getLatLongFromObject(LatLng? location) {
  if (location == null) {
    return [0.0, 0.0];
  }

  // Extract the latitude and longitude directly from the object
  return [location.latitude, location.longitude];
}

String? getGoogleMapsUrl(LatLng? location) {
  // Check if the location is null to prevent crashes
  if (location == null) {
    return '';
  }

  // Return the latitude and longitude separated by a single space
  return '${location.latitude} ${location.longitude}';
}
