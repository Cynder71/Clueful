import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 221, 207),
        title: Text(
          'Profile',
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w500
          ),
          ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 100, 
              backgroundImage: AssetImage('images/Cat.png'),
            ),
            const SizedBox(height: 40), 
            const Text(
              'Exemplo da Silva', 
              style: TextStyle(
                fontSize: 25, 
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), 
            const Text(
              'exemplo@example.com',
              style: TextStyle(
                fontSize: 18, 
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40), 
            ElevatedButton(
              onPressed: () {
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 15, 
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
