import 'package:flutter/material.dart';
import 'reservation.dart';

class StationInfoPage extends StatelessWidget {
  final String stationName = 'Station Name';
  final String stationAddress = 'Station Address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Station Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Station Name: $stationName',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(Icons.star_border, size: 24.0), 
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Station Address: $stationAddress',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 200, 
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('Station Image Placeholder'), 
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationPage(),
                        ),
                      );
                    },
                    child: Text('Make a Reservation'),
                  ),
                  SizedBox(width: 10), 
                  ElevatedButton(
                    onPressed: () {
                  
                    },
                    child: Text('Navigate'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




