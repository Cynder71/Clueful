import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Outfit.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectOutfitScreen extends StatelessWidget {
  final Function(Outfit) onSelect;

  SelectOutfitScreen({Key? key, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Escolha um Look',
          style: GoogleFonts.cinzelDecorative(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color:  const Color.fromARGB(255, 241, 221, 207),
          ),
          ),
        backgroundColor:  const Color.fromARGB(255, 58, 25, 52),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('outfits').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var outfits = snapshot.data!.docs.map((doc) => Outfit.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            itemCount: outfits.length,
            itemBuilder: (context, index) {
              var outfit = outfits[index];
              return GestureDetector(
                onTap: () {
                  onSelect(outfit);
                  Navigator.pop(context);
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
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                                childAspectRatio: 1.0,
                              ),
                              itemCount: min(outfit.itemIds.length, 4),
                              itemBuilder: (context, index) {
                                return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance.collection('items').doc(outfit.itemIds[index]).get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(color: Colors.grey[200]); // Placeholder
                                    }
                                    var itemData = snapshot.data!.data() as Map<String, dynamic>;
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        itemData['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                );
                              },
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                            if (outfit.itemIds.length > 4)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: Center(
                                    child: Text(
                                      '+${outfit.itemIds.length - 4}',
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
                          outfit.name,
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
}
