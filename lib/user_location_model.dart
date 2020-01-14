import 'dart:core';

class UserLocation {
  static final int userLocationVersion = 2;

  static final String keyTimestamp = "timestamp";
  static final String keyLatitude = "latitude";
  static final String keyLongitude = "longitude";
  static final String keySource = "source";
  static final String keyActivity = "activity";

  static final String typeTimestamp = "INTEGER NOT NULL";
  static final String typeLatitude = "REAL NOT NULL";
  static final String typeLongitude = "REAL NOT NULL";
  static final String typeSource = "TEXT NOT NULL";
  static final String typeActivity = "TEXT NOT NULL";

  int timestamp;
  double latitude;
  double longitude;
  String source;
  String activity;

  UserLocation({int timestamp, double latitude, double longitude, String source, String activity}) {
    this.timestamp = timestamp;
    this.latitude = latitude;
    this.longitude = longitude;
    this.activity = activity;
    this.source = source;
  }

  factory UserLocation.fromMap(Map<String, dynamic> info) => new UserLocation(
    timestamp: info[keyTimestamp],
    latitude: info[keyLatitude],
    longitude: info[keyLongitude],
    source: info[keySource],
    activity: info[keyActivity]
  );

  Map<String, dynamic> toMap() => {
    keyTimestamp: timestamp,
    keyLatitude: latitude,
    keyLongitude: longitude,
    keySource: source,
    keyActivity: activity
  };

  static Map<String, String> keysAndTypes() => {
    keyTimestamp: typeTimestamp,
    keyLatitude: typeLatitude,
    keyLongitude: typeLongitude,
    keySource: typeSource,
    keyActivity: typeActivity
  };
}