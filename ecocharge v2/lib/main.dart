import 'package:ecocharge/Features/Reservation/reservation.dart';
import 'package:ecocharge/Features/splash_screen/splash_screen.dart';
import 'package:ecocharge/Features/user_auth/presentation/pages/home_page.dart';
import 'package:ecocharge/Features/user_auth/presentation/pages/login_page.dart';
import 'package:ecocharge/Features/user_auth/presentation/pages/profile_page.dart';
import 'package:ecocharge/Features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:ecocharge/Map/map_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCsHDQtI9DItQgSqwy45_y2xG9tDGxuER8",
        appId: "1:540215271818:web:8b22d4aee01acdce862873",
        messagingSenderId: "540215271818",
        projectId: "flutter-firebase-9c136",
        // our web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/reservation': (context) => ReservationPage(),
        '/map': (context) => MapScreen(),
        '/profile': (context) => ProfilePage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}