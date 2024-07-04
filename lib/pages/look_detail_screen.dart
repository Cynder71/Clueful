import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:flutter_app/models/Outfit.dart';
import 'package:flutter_app/pages/SelectClothesScreen.dart';
import 'package:flutter_app/pages/wardrobe_screen.dart';
import 'package:flutter_app/backend/OutfitController.dart';
import 'package:google_fonts/google_fonts.dart';

class EditOutfitScreen extends StatefulWidget {
  final Outfit outfit;
  final List<Item>? selectedItems;

  const EditOutfitScreen({Key? key, required this.outfit, this.selectedItems})
      : super(key: key);

  @override
  EditOutfitScreenState createState() => EditOutfitScreenState();
}

class EditOutfitScreenState extends State<EditOutfitScreen> {
  final TextEditingController _nameController = TextEditingController();
  List<String> selectedItemIds = [];
  List<Item> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.outfit.name;
    selectedItemIds = widget.selectedItems?.map((item) => item.id).toList() ??
        widget.outfit.itemIds;
    selectedItems = widget.selectedItems ?? [];
    if (selectedItems.isEmpty) {
      _fetchSelectedItems();
    }
  }

  Future<void> _fetchSelectedItems() async {
    List<Item> fetchedItems = [];
    for (String itemId in selectedItemIds) {
      Item item = await _getItemById(itemId);
      fetchedItems.add(item);
    }
    setState(() {
      selectedItems = fetchedItems;
    });
  }

  Future<Item> _getItemById(String itemId) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('items').doc(itemId).get();
    return Item.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  void _saveOutfit() async {
    String name = _nameController.text.trim();
    if (name.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Por favor, insira um nome para o outfit.')),
        );
      }
      return;
    }

    await updateOutfit(widget.outfit.id, name, selectedItemIds);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WardrobeScreen(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Outfit atualizado com sucesso!')),
      );
    }
  }

  void _deleteOutfit() async {
    await deleteOutfit(widget.outfit.id);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Outfit excluído com sucesso!')),
      );
    }
  }

  void _editItems() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectClothesScreen(
          initialSelectedItems: selectedItemIds,
          origin: 'EditOutfitScreen',
          outfit: widget.outfit, // Passa o outfit atual
        ),
      ),
    );

    if (result != null && result is List<String>) {
      setState(() {
        selectedItemIds = result;
        _fetchSelectedItems();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        title: Text(
          'Editar Outfit',
          style: GoogleFonts.cinzel(
            color: Colors.white,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            color: const Color.fromARGB(255, 241, 221, 207),
            onPressed: _deleteOutfit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Outfit',
                ),
              ),
              const SizedBox(height: 20.0),
              CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: selectedItems.map((item) {
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
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _editItems,
                child: const Text('Editar Roupas'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _saveOutfit,
                child: const Text('Salvar Outfit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
