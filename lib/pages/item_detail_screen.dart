import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:flutter_app/utils/FirebaseStorageService.dart';
import 'package:flutter_app/utils/ImagePickerService.dart';
import 'package:image_picker/image_picker.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late TextEditingController _nameController;
  File? _newImage;
  final picker = ImagePicker();
  CollectionReference itemsRef = FirebaseFirestore.instance.collection('items');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateItem() async {
    if (_newImage != null) {
      String imageUrl = await FirebaseStorageService.uploadImage(_newImage!);
      await itemsRef.doc(widget.item.id).update({
        'imageUrl': imageUrl
      });
    }

    await itemsRef.doc(widget.item.id).update({
      'name' : _nameController.text
    });

    Navigator.pop(context);
  }

  Future<void> _deleteItem() async {
    await FirebaseStorage.instance.refFromURL(widget.item.imageUrl).delete();
    await itemsRef.doc(widget.item.id).delete();
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerService.pickImage();

    setState(() {
      if (pickedFile != null) {
        _newImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da roupa'),
        actions: [
          IconButton(onPressed: _deleteItem, icon: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _newImage != null ?
                Image.file(_newImage!)
                : Image.network(widget.item.imageUrl),
            const SizedBox(height: 20.0,),
            ElevatedButton(onPressed: _pickImage, child: const Text('Escolher nova imagem')),
            const SizedBox(height: 20,),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: _updateItem, child: const Icon(Icons.save))
          ],
        ),
      ),
    );
  }
}
