import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateOutfitScreen extends StatefulWidget {
  final List<Item> selectedItems;

  const CreateOutfitScreen({Key? key, required this.selectedItems})
      : super(key: key);

  @override
  CreateOutfitScreenState createState() => CreateOutfitScreenState();
}

class CreateOutfitScreenState extends State<CreateOutfitScreen> {
  final TextEditingController _nameController = TextEditingController();
  Map<String, Offset> itemPositions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Criar Outfit',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveOutfit,
          ),
        ],
      ),
      body: Stack(
        children: widget.selectedItems.map((item) {
          return Positioned(
            left: itemPositions[item.id]?.dx ?? 100,
            top: itemPositions[item.id]?.dy ?? 100,
            child: Draggable(
              data: item.id,
              feedback: Opacity(
                opacity: 0.5,
                child: Image.network(item.imageUrl, width: 100, height: 150),
              ),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  itemPositions[item.id] = details.offset;
                });
              },
              child: Image.network(item.imageUrl, width: 100, height: 150),
            ),
          );
        }).toList(),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nome do Outfit',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  void _saveOutfit() async {
    String name = _nameController.text;
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

    await FirebaseFirestore.instance.collection('outfits').add({
      'name': name,
      'itemIds': itemIds,
    });

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Outfit salvo com sucesso!')),
      );
    }
  }
}
