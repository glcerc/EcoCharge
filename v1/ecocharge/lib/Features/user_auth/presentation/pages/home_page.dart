import 'package:ecocharge/Common/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../common/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to different pages based on the selected index
      switch (_selectedIndex) {
        case 0:
        // Navigate to Home
        // You can add your logic or navigate to the appropriate screen


          break;
        case 1:
        // Navigate to Map
          Navigator.pushNamed(context, "/map");
          showToast(message: "Map screen loading");
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("HomePage"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "Welcome Home buddy!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          )),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
              showToast(message: "Successfully signed out");
            },
            child: Container(
              height: 45,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "Sign out",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/map");
              showToast(message: "Map screen loading");
            },
            child: Container(
              height: 45,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "Map",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),

          bottomNavigationBar: BottomNavBar(
            selectedIndex: 0,
            onItemTapped: _onItemTapped,
        ),
    );
  }
}
