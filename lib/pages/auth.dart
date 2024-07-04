import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login_screen.dart';
import 'package:flutter_app/pages/navigation_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //user is in
            if(snapshot.hasData){
              return const NavigationPage();
            }
            else {
              return const LoginScreen();
            }
          //user is out
        }
      ),
    );
  }
}