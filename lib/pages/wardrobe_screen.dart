/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:flutter_app/pages/item_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 241, 221, 207),
        appBar: AppBar(
            title: Text(
              'Meu Guarda-Roupa',
              style: GoogleFonts.cinzel(
                color: const Color.fromARGB(255, 241, 221, 207),
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 58, 25, 52),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: const Color.fromARGB(255, 241, 221, 207),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Roupas',
                ),
                Tab(
                  text: 'Looks',
                )
              ],
            )),
        body: TabBarView(children: [
          Center(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('items').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var items = snapshot.data!.docs.map((doc) {
                  return Item.fromMap(
                      doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio:
                        0.75, // Ajuste a proporção conforme necessário
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetailScreen(item: item),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                ),
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:flutter_app/pages/item_detail_screen.dart';
import 'package:flutter_app/pages/SelectClothesScreen.dart'; // Import necessário para LookDetailScreen
import 'package:google_fonts/google_fonts.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 241, 221, 207),
        appBar: AppBar(
          title: Text(
            'Meu Guarda-Roupa',
            style: GoogleFonts.cinzel(
              color: const Color.fromARGB(255, 241, 221, 207),
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 58, 25, 52),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Roupas',
              ),
              Tab(
                text: 'Looks',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildItemsTab(),
            _buildLooksTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTab() {
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var items = snapshot.data!.docs.map((doc) {
            return Item.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailScreen(item: item),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLooksTab() {
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('outfits').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var outfits = snapshot.data!.docs.map((doc) {
            return Look.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          // Obtenha a lista de items fora do StreamBuilder de items
          var itemsFuture =
              FirebaseFirestore.instance.collection('items').get();

          return FutureBuilder<QuerySnapshot>(
            future: itemsFuture,
            builder: (context, itemsSnapshot) {
              if (itemsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Converte o snapshot de items em uma lista de Item
              var items = itemsSnapshot.data!.docs.map((doc) {
                return Item.fromMap(doc.data() as Map<String, dynamic>, doc.id);
              }).toList();

              return GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: outfits.length,
                itemBuilder: (context, index) {
                  var look = outfits[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectClothesScreen(),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                // Mini grid de até 4 peças do look
                                GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                    childAspectRatio: 1.0,
                                  ),
                                  itemCount: look.itemIds.length > 4
                                      ? 4
                                      : look.itemIds.length,
                                  itemBuilder: (context, index) {
                                    var itemId = look.itemIds[index];
                                    var item = _getItemById(itemId,
                                        items); // Passando a lista de items
                                    if (item != null) {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          item.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Desabilita o scroll do mini grid
                                ),
                                // Overlay para indicar mais itens
                                if (look.itemIds.length > 4)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black.withOpacity(0.5),
                                      child: Center(
                                        child: Text(
                                          '+${look.itemIds.length - 4}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              look.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Item? _getItemById(String itemId, List<Item> items) {
    // Busca o item na lista de items usando o itemId
    try {
      return items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }
}

class Look {
  final String id;
  final String name;
  final List<String> itemIds;

  Look({
    required this.id,
    required this.name,
    required this.itemIds,
  });

  factory Look.fromMap(Map<String, dynamic> map, String id) {
    return Look(
      id: id,
      name: map['name'],
      itemIds: List<String>.from(map['itemIds']),
    );
  }
}
