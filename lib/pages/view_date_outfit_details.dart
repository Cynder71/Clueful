import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:flutter_app/models/Outfit.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewDateOutfitScreen extends StatefulWidget {
  final String dateOutfitId;

  const ViewDateOutfitScreen({Key? key, required this.dateOutfitId}) : super(key: key);

  @override
  _ViewDateOutfitScreenState createState() => _ViewDateOutfitScreenState();
}

class _ViewDateOutfitScreenState extends State<ViewDateOutfitScreen> {
  late Outfit outfit;
  List<Item> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDateOutfit();
  }

  Future<void> _loadDateOutfit() async {
    try {
      DocumentSnapshot dateOutfitDoc = await FirebaseFirestore.instance
          .collection('dateOutfits')
          .doc(widget.dateOutfitId)
          .get();

      String outfitId = dateOutfitDoc['outfitId'];
      DocumentSnapshot outfitDoc = await FirebaseFirestore.instance
          .collection('outfits')
          .doc(outfitId)
          .get();

      Outfit loadedOutfit = Outfit.fromMap(outfitDoc.data() as Map<String, dynamic>, outfitDoc.id);
      List<Item> loadedItems = [];

      for (String itemId in loadedOutfit.itemIds) {
        DocumentSnapshot itemDoc = await FirebaseFirestore.instance
            .collection('items')
            .doc(itemId)
            .get();
        loadedItems.add(Item.fromMap(itemDoc.data() as Map<String, dynamic>, itemDoc.id));
      }

      setState(() {
        outfit = loadedOutfit;
        items = loadedItems;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading outfit details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading outfit details')),
      );
    }
  }

  void _deleteDateOutfit() async {
    await FirebaseFirestore.instance.collection('dateOutfits').doc(widget.dateOutfitId).delete();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Date outfit removed successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        title: Text(
          'View Outfit',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 58, 25, 52),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color.fromARGB(255, 241, 221, 207),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            color: const Color.fromARGB(255, 241, 221, 207),
            onPressed: _deleteDateOutfit,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                outfit.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: items.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Card(
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
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
