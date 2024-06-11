import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


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
            alignment: Alignment.bottomCenter, // Adjust alignment as needed
            child: IconButton(
              icon: const Icon(Icons.settings, color: Color.fromARGB(255, 58, 25, 52)),
              onPressed: () {   // Add your settings button logic here
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinhar à esquerda
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 25),
                  child: Text(
                      'Veja aqui o seu look do dia!', // Add your text here
                      style: GoogleFonts.lora(
                        fontSize: 22,
                      ),
                ),
              ),
            const SizedBox(height: 30),

              Row(
                children: [
                  Image.asset(
                    'images/teste.png',
                    height: 240,
                    width: 240,
                  ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Color.fromARGB(255, 58, 25, 52)),
                      iconSize: 40,
                      onPressed: () {},
                    ),
                ],
              ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Veja outras combinações', // Add your text here
                style: GoogleFonts.lora(
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(height: 25), // Add some space between text and CarouselSlider
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
                enableInfiniteScroll: false, // Set this to false to disable looping
              ),
            ),
          ],
        ),
      ),
    );
  }
}
