import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:timeline/history_widget.dart';

import 'location_storage.dart';
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
  GoogleMapController _mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  MarkerId _currentPos = MarkerId("Current Position");

  _onMapCreated(GoogleMapController controller) async {
    debugPrint("onMapCreated()");
    _mapController = controller;
    await bg.BackgroundGeolocation.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();

    //Define location event callbacks
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      debugPrint('[location] - $location');
      LatLng ll = LatLng(location.coords.latitude, location.coords.longitude);
      _updateMapLocation(ll);
      _updateLocationMarker(ll);
      LocationStorage.storeLocation(
        UserLocation(
          activity: location.activity.toString(),
          latitude: ll.latitude,
          longitude: ll.longitude,
          timestamp: DateTime.parse(location.timestamp).millisecondsSinceEpoch,
          source: "location"
        )
      );
    });

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      debugPrint('[motionChange] - $location');
      LatLng ll = LatLng(location.coords.latitude, location.coords.longitude);
      _updateMapLocation(ll);
      _updateLocationMarker(ll);
      LocationStorage.storeLocation(
        UserLocation(
          activity: location.activity.toString(),
          latitude: ll.latitude,
          longitude: ll.longitude,
          timestamp: DateTime.parse(location.timestamp).millisecondsSinceEpoch,
          source: "location"
        )
      );
    });

    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      debugPrint('[providerchange] = $event');
    });

    bg.BackgroundGeolocation.onHeartbeat((bg.HeartbeatEvent event) {
      debugPrint('[heartbeat] - $event.location');
    });

    bg.BackgroundGeolocation.ready(
      bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 100.0,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: false,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      preventSuspend: true,
      heartbeatInterval: 0,
    )).then((bg.State state) {
      if(!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });
  }

  _updateMapLocation(LatLng ll) async {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: ll,
          zoom: 17,
        )
      )
    );
  }

  _updateLocationMarker(LatLng ll) async {
    Marker marker = Marker(
      markerId: _currentPos,
      position: ll
    );

    setState(() {
      _markers[_currentPos] = marker;
    });
  }

  _onChooseOverlay(int minutes) async {
    _polylines.clear();
    List<LatLng> points = List<LatLng>();

    if(minutes > 0) {
      var results = await LocationStorage.getResults(minutes);
      results.forEach((row) => points.insert(0, LatLng(row['latitude'], row['longitude'])));
    }
    
    PolylineId polyId = PolylineId("History");
    Polyline poly = Polyline(
      polylineId: polyId,
      points: points,
      color: Colors.blue,
    );

    setState(() {
      _polylines[polyId] = poly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.green[700],
        ),
        body: SlidingUpPanel(
          backdropEnabled: true,
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(0,0),
              zoom: 7.0,
            ),
            markers: Set<Marker>.of(_markers.values),
            polylines: Set<Polyline>.of(_polylines.values),
          ),
          panel: Center(
            child: HistoryWidget.Open(_onChooseOverlay),
          ),
          collapsed: HistoryWidget.Closed(),
        ) 
      ),
    );
  }
}
