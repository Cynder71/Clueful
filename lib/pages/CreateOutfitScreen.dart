import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/pages/add_item_screen.dart';

class CreateOutfitScreen extends StatefulWidget {
  final List<Item> selectedItems;

  const CreateOutfitScreen({Key? key, required this.selectedItems})
      : super(key: key);

  @override
  CreateOutfitScreenState createState() => CreateOutfitScreenState();
}

class CreateOutfitScreenState extends State<CreateOutfitScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 241, 221, 207),
        appBar: AppBar(
          title: Text(
            'Criar Outfit',
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
              icon: const Icon(Icons.save),
              color: const Color.fromARGB(255, 241, 221, 207),
              onPressed: _saveOutfit,
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: widget.selectedItems.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              // Campo para inserir o nome do outfit
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Outfit',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        )));
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

    List<String> itemIds = widget.selectedItems.map((item) => item.id).toList();

    // Salvar o outfit no Firestore
    await FirebaseFirestore.instance.collection('outfits').add({
      'name': name,
      'itemIds': itemIds,
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChoicePage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Outfit salvo com sucesso!')),
      );
    }
  }
}
