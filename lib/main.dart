import 'package:contact_app/pages/home_screen.dart';
import 'package:contact_app/pages/login_screen.dart';
import 'package:contact_app/services/auth_service.dart';
import 'package:contact_app/services/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool? result = await isLoggedIn();
  runApp(MyApp(result!));
}

class MyApp extends StatelessWidget {
  MyApp(this.isLoggedIn);
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}

isLoggedIn() async {
  bool? result = await UserService().getData();
  return result;
}
