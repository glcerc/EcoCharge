import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocharge/Common/Toast.dart';
import 'package:ecocharge/Common/bottom_nav_bar.dart';
import 'package:ecocharge/Features/Reservation/reservation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapboxMapController mapController;
  late Position currentLocation;
  MapboxMap? mapboxMap;

  final String accessToken =
      'sk.eyJ1IjoiYmFzYWt0dXlzdXoiLCJhIjoiY2xxMnA0OHgxMDM3eTJpbzR0YjYzM3ZuaCJ9.VAPsg2uAHOUutHfEQNW1xg';

  //secret olanı bu

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to different pages based on the selected index
      switch (_selectedIndex) {
        case 0:
        // Navigate to Home
        // You can add your logic or navigate to the appropriate screen
          Navigator.pushNamed(context, "/home");

          break;
        case 1:
          break;
        case 2:
        // Navigate to Profile or any other screen
        // You can add your logic or navigate to the appropriate screen
          break;
        default:
        // Navigate to Home as default
        // You can add your logic or navigate to the appropriate screen
          break;
      }
    });
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _queryFeaturesAtPoint(Point<double> screenPoint) async {
    final features =
        mapController.queryRenderedFeatures(screenPoint, ['symbols'], null);

    //'symbols' is the layer ıd of our map
    if (mapController != null) {
      features.then((value) {
        print("Features: ${value.map((e) => e.toString())}"); //to test

        // Accessing individual feature properties and using clickedFeature
        for (var feature in value) {
          String featureName = feature['properties']['name'];
          String featureConnectionType =
              feature['properties']['connectionType'];
          String featureDescription = feature['properties']['description'];

          // putting values inside clicked feature
          Map<String, dynamic> clickedFeature = {
            "name": featureName,
            "connectionType": featureConnectionType,
            "description": featureDescription,
          };
          _showBottomSheet(context, clickedFeature);
        }
      });
    }
  }

  //get user location I found this code on mapbox flutter documentation
  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLocation = position;
      _updateCameraPosition();
    });
  }

  void _updateCameraPosition() {
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(
          LatLng(currentLocation.latitude, currentLocation.longitude)));
    }
  }

  //creating bottomsheet and filling texts with values
  void _showBottomSheet(
      BuildContext context, Map<String, dynamic> clickedFeature) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        clickedFeature["name"],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(onPressed: () async {
                      await _addToFavorites(
                        title: clickedFeature['name'],
                        address: clickedFeature['description'],
                        country: "Turkıye", // Replace with actual country value
                      );
                    }, icon: Icon(Icons.star_border, size: 24.0),)


                  ],
                ),
                SizedBox(height: 10),
                Text(
                  clickedFeature["connectionType"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  clickedFeature["description"],
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle navigation or other actions
                        // Replace this with your actual logic
                        // Close bottom sheet
                      },
                      child: Text('Start Navigation'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle reservation or other actions
                        // Replace this with your actual logic
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReservationPage()),

                        ); // Close bottom sheet
                      },
                      child: Text('Make Reservation'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoCharge'),
        backgroundColor: Colors.orange,
      ),
      body: MapboxMap(
        myLocationEnabled: true,
        myLocationTrackingMode: MyLocationTrackingMode.Tracking,
        accessToken: accessToken,
        onMapCreated: _onMapCreated,
        onMapClick: (point, latLng) async {
          _queryFeaturesAtPoint(point);

        },
        styleString: "mapbox://styles/basaktuysuz/clq2ny4mt01sh01qt1hd2d4zx",
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 11.0,
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onItemTapped: _onItemTapped,
      ),

    );
  }

  Future<void> _addToFavorites ({
    required String title,
    required String address,
    required String country,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final CollectionReference favoritePlacesRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('favoritePlaces');


    Map<String, dynamic> favoritePlaceData = {
      'title': title,
      'address': address,
      'country': country,
    };

    await favoritePlacesRef.doc(title).set(favoritePlaceData);

  }
}
