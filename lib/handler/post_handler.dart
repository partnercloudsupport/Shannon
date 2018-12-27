import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class PostHandler {
  var path = "posts";

  submit(text) async {
    final prefs = await SharedPreferences.getInstance();

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high).catchError((e){
          print(e.toString());
        });

    print(position.latitude);
    print(position.longitude);
    // first build the data map.
    var data = {
      "text": prefs.getString(text),
      "user": prefs.getString("user"),
      // "flair": prefs.getString("flair"),
      "flair": "Computing",
      "location": GeoPoint(position.latitude, position.longitude),
      "date": DateTime.now().millisecondsSinceEpoch,
    };

    await Firestore.instance
        .collection(path)
        .document()
        .setData(data)
        .whenComplete(() {
      // prefs.setString("user", user);
      // value = true;
    }).catchError((e) {
      // value = false;
    });
    // return value;
  }
}
