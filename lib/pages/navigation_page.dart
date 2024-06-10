import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/calendar_screen.dart';
import 'package:flutter_app/pages/home_screen.dart';
import 'package:flutter_app/pages/profile_screen.dart';
import 'package:flutter_app/pages/wardrobe_screen.dart';
import 'package:flutter_app/pages/add_item_screen.dart';


class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

const iconList = [
  Icons.home,
  Icons.door_sliding_sharp,
  Icons.calendar_month,
  Icons.person
];

const List<Widget> screens = [
  HomeScreen(),
  WardrobeScreen(),
  CalendarScreen(),
  ProfileScreen(),
];


class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 186, 144, 198),
         onPressed: () {
        // Navigate to AddItem screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItem()), // Replace with your AddItem widget
         );
        },
        shape: const CircleBorder(), // Use CircleBorder for a circular shape
        child: const Icon(Icons.add, color: Colors.black,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        inactiveColor: const Color.fromARGB(255, 186, 144, 198),
        activeColor:  const Color.fromARGB(255, 253, 244, 245),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        icons: iconList,
        onTap: (index) => setState(() => _currentIndex = index),
        activeIndex: _currentIndex,
      ),
      body: screens[_currentIndex],
    );
  }
}