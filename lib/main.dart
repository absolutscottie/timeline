import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:timeline/location_storage.dart';
import 'user_location_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Timeline Test Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _lastLatLong = "unknown";

  void _setLastLatLong(double lat, double long) {
    setState(() {
      _lastLatLong = lat.toString() + ", " + long.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    debugPrint('[initstate] - begin!');

    //Define location event callbacks
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      debugPrint('[location] - $location');
      _storeLocation(location, "location");
    });

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      debugPrint('[motionChange] - $location');
    });

    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      debugPrint('[providerchange] = $event');
    });

    bg.BackgroundGeolocation.onHeartbeat((bg.HeartbeatEvent event) {
      debugPrint('[heartbeat] - $event.location');
      _storeLocation(event.location, "heartbeat");
    });

    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10.0,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      preventSuspend: true,
      heartbeatInterval: 1,
    )).then((bg.State state) {
      if(!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });

    debugPrint('[initstate] - end! ');
  }

  void _storeLocation(bg.Location location, String source) async {
    _setLastLatLong(location.coords.latitude, location.coords.longitude);
    try {
        var timestamp = DateTime.parse(location.timestamp).millisecondsSinceEpoch;
        var lat = location.coords.latitude;
        var long = location.coords.longitude;
        var activity = location.activity.type;

        var ul = UserLocation(timestamp: timestamp, latitude:lat, longitude:long, activity:activity, source:source);

        await LocationStorage.storeLocation(ul);
        debugPrint('Successfully inserted $lat - $long to storage');
      } catch(e) {
        debugPrint('Failed to get lat and long from location callback: $e');
      }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your last know location was:',
            ),
            Text(
              '$_lastLatLong',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
