import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shannon/globals/strings.dart';
import 'package:android_intent/android_intent.dart';

class PostHandler {
  var value = false;

  Future<bool> submit(content) async {
    final prefs = await SharedPreferences.getInstance();
    var geoLocator = Geolocator();
    var status = await geoLocator.checkGeolocationPermissionStatus();
    Position position;

    //Check if location available first.
    if (status == GeolocationStatus.denied ||
        status == GeolocationStatus.granted) {
      position = await geoLocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      //First build the data map.
      var data = {
        "content": content,
        "username": prefs.getString("username"),
        "flair": prefs.getString("flair"),
        "location": GeoPoint(position.latitude, position.longitude),
        "date": DateTime.now().millisecondsSinceEpoch,
      };

      await Firestore.instance
          .collection(postPath)
          .document()
          .setData(data)
          .whenComplete(() {
        value = true;
      }).catchError((e) {
        value = false;
      });
      
    } else if (status == GeolocationStatus.disabled) {
      final AndroidIntent intent = new AndroidIntent(
        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
      );
      intent.launch();
      return false;
    } else if (status == GeolocationStatus.restricted ||
        status == GeolocationStatus.unknown) {
      return false;
    }

    return value;
  }
}
