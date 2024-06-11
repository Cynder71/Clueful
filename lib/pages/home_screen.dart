import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/pages/wardrobe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 221, 207),
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Clueful',
            style: GoogleFonts.cinzelDecorative(
              fontSize: 38,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              icon: const Icon(Icons.settings,
                  color: Color.fromARGB(255, 58, 25, 52)),
              onPressed: () {
                // Add your settings button logic here
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text(
                      'Veja aqui o seu look do dia!',
                      style: GoogleFonts.lora(
                        fontSize: 22,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward,
                          color: Color.fromARGB(255, 58, 25, 52)),
                      iconSize: 20,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 58, 25, 52),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // Child widget or content inside the container
                ),
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text(
                      'Veja aqui suas roupas',
                      style: GoogleFonts.lora(
                        fontSize: 22,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward,
                          color: Color.fromARGB(255, 58, 25, 52)),
                      iconSize: 20,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WardrobeScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              CarouselSlider(
                items: [1, 2, 3, 4, 5].map((i) {
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 58, 25, 52),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "text $i",
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  enableInfiniteScroll: false,
                ),
              ),
              const SizedBox(height: 50), // Add some space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
