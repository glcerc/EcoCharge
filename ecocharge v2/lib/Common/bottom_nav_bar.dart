import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });


  static const List<Color> _bgColors = [
    Colors.red,     //color for home
    Colors.green,   //color for map
    Colors.purple,  //color for profile
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
          backgroundColor: Colors.purple,
        ),
      ],

      currentIndex: selectedIndex,
      //selected item bg
      selectedItemColor: Colors.amber[800],
      onTap: onItemTapped,
      backgroundColor: _bgColors[selectedIndex],


    );
  }
}