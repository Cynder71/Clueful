import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/add_form.dart';
import 'package:flutter_app/pages/SelectClothesScreen.dart';
import 'package:flutter_app/pages/calendar_screen.dart';
import 'package:flutter_app/pages/look_detail_screen.dart';
import 'package:flutter_app/pages/wardrobe_screen.dart';
import '../models/Outfit.dart';
import '../models/Item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Outfit?>? _lookOfTheDay;
  List<Item> items = []; // Lista de items (roupas)

  @override
  void initState() {
    super.initState();
    _lookOfTheDay = getDateOutfitForToday();
    fetchItems();
  }

  Future<void> fetchItems() async {
    var snapshots = await FirebaseFirestore.instance.collection('items').get();
    items = snapshots.docs
        .map((doc) => Item.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    setState(() {});
  }

  Future<Outfit?> getDateOutfitForToday() async {
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime endOfDay =
        DateTime(today.year, today.month, today.day, 23, 59, 59);

    var snapshots = await FirebaseFirestore.instance
        .collection('dateOutfits')
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThanOrEqualTo: endOfDay.toIso8601String())
        .get();

    if (snapshots.docs.isNotEmpty) {
      String outfitId = snapshots.docs.first.data()['outfitId'] as String;
      var outfitSnapshot = await FirebaseFirestore.instance
          .collection('outfits')
          .doc(outfitId)
          .get();
      if (outfitSnapshot.exists) {
        return Outfit.fromMap(
            outfitSnapshot.data()! as Map<String, dynamic>, outfitSnapshot.id);
      }
    }
    return null;
  }

  Item? _getItemById(String itemId) {
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  @override
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
              FutureBuilder<Outfit?>(
                future: _lookOfTheDay,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return _buildEmptyCarousel('Erro ao carregar look do dia.');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return _buildEmptyCarousel(
                        'Não existe look agendado para hoje.');
                  } else {
                    return _buildLooksOfTheDayCarousel(snapshot.data!);
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitleWithArrow(
                'Veja aqui seus looks',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WardrobeScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildOutfitsCarousel(), // Aqui utilizamos o novo método
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

  Widget _buildSectionTitleWithArrow(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color.fromARGB(255, 58, 25, 52),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward,
              color: Color.fromARGB(255, 58, 25, 52)),
          onPressed: onTap,
        ),
      ],
    );
  }

  Widget _buildLooksOfTheDayCarousel(Outfit outfit) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditOutfitScreen(
                outfit: outfit,
              ),
            ));
      },
      child: CarouselSlider(
        options: CarouselOptions(
          height: 290,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
        ),
        items: [outfit].map((outfit) {
          return Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 1.0,
              ),
              itemCount: outfit.itemIds.length > 4 ? 4 : outfit.itemIds.length,
              itemBuilder: (context, index) {
                var itemId = outfit.itemIds[index];
                var item = _getItemById(itemId);
                if (item != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemsCarousel() {
    if (items.isEmpty) {
      return _buildEmptyCarousel('Nenhuma roupa encontrada.');
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        viewportFraction: 0.6,
      ),
      items: items.take(5).map((item) {
        return Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOutfitsCarousel() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('outfits').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildEmptyCarousel('Carregando looks...');
        }

        var outfits = snapshot.data!.docs.map((doc) {
          return Outfit.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        // Obter a lista de items uma única vez fora do StreamBuilder de items
        var itemsFuture = FirebaseFirestore.instance.collection('items').get();

        return FutureBuilder<QuerySnapshot>(
          future: itemsFuture,
          builder: (context, itemsSnapshot) {
            if (itemsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Converter o snapshot de items em uma lista de Item
            var items = itemsSnapshot.data!.docs.map((doc) {
              return Item.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            }).toList();

            return CarouselSlider(
              options: CarouselOptions(
                height: 290,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
              items: outfits.map((outfit) {
                return Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount:
                        outfit.itemIds.length > 4 ? 4 : outfit.itemIds.length,
                    itemBuilder: (context, index) {
                      var itemId = outfit.itemIds[index];
                      var item = _getItemById(itemId);
                      if (item != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyCarousel(String message) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.grey.shade200,
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
