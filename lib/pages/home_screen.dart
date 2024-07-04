
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/add_form.dart';
import 'package:flutter_app/pages/SelectClothesScreen.dart';
import 'package:flutter_app/pages/calendar_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/Outfit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<Outfit?> getDateOutfitForToday() async {
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    var snapshots = await FirebaseFirestore.instance
        .collection('dateOutfits')
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThanOrEqualTo: endOfDay.toIso8601String())
        .get();

    if (snapshots.docs.isNotEmpty) {
      String outfitId = snapshots.docs.first.data()['outfitId'] as String;
      var outfitSnapshot = await FirebaseFirestore.instance.collection('outfits').doc(outfitId).get();
      if (outfitSnapshot.exists) {
        return Outfit.fromMap(outfitSnapshot.data()! as Map<String, dynamic>, outfitSnapshot.id);
      }
    }
    return null;
  }
  Widget build(BuildContext context) {
    // Dados mockados do usuário
    final String userName = 'Usuário Mock';
    final String userPhotoUrl = 'https://via.placeholder.com/150';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userPhotoUrl),
                ),
                const SizedBox(width: 10),
                Text(
                  'Oi, $userName',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 58, 25, 52),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMenuButton(
                    context,
                    'Adicione roupas',
                    Icons.shopping_bag,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddItem()),
                      );
                    },
                  ),
                  _buildMenuButton(
                    context,
                    'Crie looks',
                    Icons.door_sliding_sharp,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectClothesScreen(
                                  origin: 'ChoicePage',
                                )),
                      );
                    },
                  ),
                  _buildMenuButton(
                    context,
                    'Agende seus looks',
                    Icons.calendar_today,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CalendarScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Veja aqui seus looks do dia'),
              const SizedBox(height: 10),
              _buildLooksOfTheDayCarousel(),
              const SizedBox(height: 20),
              _buildSectionTitle('Veja aqui suas roupas'),
              const SizedBox(height: 10),
              _buildItemsCarousel(),
              const SizedBox(height: 20),
              _buildSectionTitle('Veja seus looks'),
              const SizedBox(height: 10),
              _buildOutfitsCarousel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 58, 25, 52),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color.fromARGB(255, 58, 25, 52),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLooksOfTheDayCarousel() {
    // Dados mockados de looks do dia
    final List<String> looksOfTheDay = [
      'Look 1',
      'Look 2',
      'Look 3',
    ];

    if (looksOfTheDay.isEmpty) {
      return _buildEmptyCarousel('Não existe look agendado para hoje.');
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
      items: looksOfTheDay.map((look) {
        return _buildCarouselItem(look);
      }).toList(),
    );
  }

  Widget _buildItemsCarousel() {
    // Dados mockados de roupas
    final List<String> items = [
      'Roupa 1',
      'Roupa 2',
      'Roupa 3',
      'Roupa 4',
      'Roupa 5',
    ];

    if (items.isEmpty) {
      return _buildEmptyCarousel('Nenhuma roupa encontrada.');
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
      items: items.map((item) {
        return _buildCarouselItem(item);
      }).toList(),
    );
  }

  Widget _buildOutfitsCarousel() {
    // Dados mockados de looks
    final List<String> outfits = [
      'Look 1',
      'Look 2',
      'Look 3',
      'Look 4',
      'Look 5',
    ];

    if (outfits.isEmpty) {
      return _buildEmptyCarousel('Nenhum look encontrado.');
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
      items: outfits.map((outfit) {
        return _buildCarouselItem(outfit);
      }).toList(),
    );
  }

  Widget _buildCarouselItem(String item) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          item,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildEmptyCarousel(String message) {
    return Container(
      height: 150,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
