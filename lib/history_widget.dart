import 'package:flutter/material.dart';

class HistoryWidget {
  static BorderRadiusGeometry _radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  static const EdgeInsets _insets = EdgeInsets.only(top: 36.0);

  static Widget Closed() =>
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: _radius
      ),
      child: Center(
        child: Text(
          "Location History",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );


  static Widget Open(void Function(int) onPressed) =>
    Container(
      margin: _insets,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: _radius,
      ),
      child: ListView(
        children: <Widget>[
          FlatButton(
            child: Text(
              "None",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            onPressed: () {onPressed(0);},
          ),
          FlatButton(
            child: Text(
              "30 Minutes",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            onPressed: () {onPressed(30);},
          ),
          FlatButton(
            child: Text(
              "1 Hour",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            onPressed: () {onPressed(60);},
          ),
          FlatButton(
            child: Text(
              "12 Hour",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            onPressed: () {onPressed(12 * 60);},
          ),
          FlatButton(
            child: Text(
              "1 Day",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            onPressed: () {onPressed(24 * 60);},
          ),
          FlatButton(
            child: Text(
              "2 Days",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            onPressed: () {onPressed(48 * 60);},
          ),
          FlatButton(
            child: Text(
              "1 Week",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            onPressed: () {onPressed(7 * 24 * 60);},
          )
        ],
      )
    );
}