import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/pages/login_page.dart';
import 'package:rider_app/pages/main_page.dart';
import 'package:rider_app/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RiderApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");

class RiderApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rider Demo',
      theme: ThemeData(
        fontFamily: "Brand-Bold",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MainPage.idScreen,
      routes: {
        LoginPage.idScreen: (context) => LoginPage(),
        RegisterPage.idScreen: (context) => RegisterPage(),
        MainPage.idScreen: (context) => MainPage(),
      },
    );
  }
}
