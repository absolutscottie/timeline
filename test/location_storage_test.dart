import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeline/location_storage.dart';
import 'package:timeline/user_location_model.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  group('Location Storage', () {   
    test("Make sure that reads and writes to location storage work as expected", () async {
      var now = DateTime.now().millisecondsSinceEpoch;

      //might be better to use an array or something where
      //order can be guaranteed. Not sure how set is implemented
      //under the hood
      Set<UserLocation> testLocations = {};
      for(var i = 0; i < 5; i++) {
        testLocations.add(UserLocation(
          latitude: 123.4,
          longitude: 567.8,
          timestamp: now - (i * 10),
          activity: "",
          source: "",
        ));
      }

      testLocations.forEach((l) async => await LocationStorage.storeLocation(l));
      testLocations.forEach((l) async {
        var counter = 1;
        var results = await LocationStorage.getResults(l.timestamp - 5000);
        expect(results.length, counter);
        counter++;
      });
    });
  });
}