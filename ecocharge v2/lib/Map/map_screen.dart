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
import 'package:url_launcher/url_launcher.dart';





class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

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
      // navigating to different pages based on the selected index
      switch (_selectedIndex) {
        case 0:
          // Navigate to Home
          Navigator.pushNamed(context, "/home");
          break;
        case 1:
          //map is selected doing nothing
          break;
        case 2:
          Navigator.pushNamed(context, "/profile");
          break;
        default:
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

    double coordinateX = screenPoint.x.toDouble();
    double coordinateY = screenPoint.y.toDouble();

//TO test coordinate values
    print(coordinateX);
    print(coordinateY);

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
          double featureLatitude = feature['geometry']['coordinates'][1];
          double featureLongitude = feature['geometry']['coordinates'][0];

          // putting values inside clicked feature
          Map<String, dynamic> clickedFeature = {
            "name": featureName,
            "connectionType": featureConnectionType,
            "description": featureDescription,
            "coordinateX": featureLatitude,
            "coordinateY": featureLongitude,

          };

          _showBottomSheet(context, clickedFeature);
          print(featureLongitude);
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
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await _addToFavorites(
                          title: clickedFeature['name'],
                          address: clickedFeature['description'],
                          country: "Turkıye", //country name as default
                        );
                      },
                      icon: const Icon(Icons.star_border, size: 24.0),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  clickedFeature["connectionType"],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  clickedFeature["description"],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        launchGoogleMaps(clickedFeature);
                      },
                      child: const Text('Start Navigation'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //when tapping on make reservation going to reservation page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReservationPage()),
                        ); // Close bottom sheet
                      },
                      child: const Text('Make Reservation'),
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


  static Future<void> launchGoogleMaps(Map<String, dynamic> clickedFeature) async {
    double destinationLatitude = clickedFeature["coordinateY"];
    double destinationLongitude = clickedFeature["coordinateX"];

    String url = "http://maps.google.com/maps?daddr=$destinationLatitude,$destinationLongitude";


    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  {here we can put host}
        queryParameters: {
          'q': '$destinationLongitude,$destinationLatitude'
        });
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoCharge'),
        backgroundColor: Colors.green,
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
        initialCameraPosition: const CameraPosition(
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

  Future<void> _addToFavorites({
    required String title,
    required String address,
    required String country,
  }) async {
    showToast(message: "Station added to Favorites");
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final CollectionReference favoritePlacesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favoritePlaces');

    Map<String, dynamic> favoritePlaceData = {
      'title': title,
      'address': address,
      'country': country,
    };
    await favoritePlacesRef.doc(title).set(favoritePlaceData);
  }
}
