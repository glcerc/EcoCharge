import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> places = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoritePlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Stations'),
      ),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: ListTile(
              title: Text(places[index]['title'],
                style: const TextStyle(
                  color: Colors.blue,
                ),),

              subtitle: Text(places[index]['country'], style: const TextStyle(
                color: Colors.black87,
              ),),

              // Add more details or customize as per your document structure
            ),
          );
        },
      ),
    );
  }

  Future<void> _fetchFavoritePlaces() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        QuerySnapshot<Map<String, dynamic>> favoritesSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('favoritePlaces')
            .get();

        final allData =
        favoritesSnapshot.docs.map((doc) => doc.data()).toList();
        places.addAll(allData);

        print(allData);

        setState(() {});
      } catch (e) {
        print('Error');
      }
    }
  }
}
