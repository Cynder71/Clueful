import 'package:cloud_firestore/cloud_firestore.dart';
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
}
