import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddClothes extends StatefulWidget {
  const AddClothes({super.key});

  @override
  State<AddClothes> createState() => AddClothesState();
}

class AddClothesState extends State<AddClothes> {
  final List<String> _tags = ["frio", "calor", "dia a dia", "festa", "rolê"];
  final List<String> _selectedTags = [];
  final TextEditingController _nicknameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();
  File? imageFile;

  Future<void> pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Tirar Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Selecionar da Galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addClothes() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("Imagem: $imageFile");
      print("Categorias: $_selectedTags");
      print("Apelido: ${_nicknameController.text}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Roupa salva! :D')),
      );
      // Implementar a lógica para adicionar a nova roupa
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova roupa'),
        backgroundColor: const Color.fromARGB(255, 186, 144, 198),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                FormField<File?>(
                  initialValue: imageFile,
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione uma imagem.';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: _showImageSourceActionSheet,
                              child: SizedBox(
                                width: 300,
                                height: 300,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: imageFile == null
                                      ? const Icon(Icons.camera_alt, size: 50)
                                      : Image.file(
                                          imageFile!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: FloatingActionButton(
                                mini: true,
                                backgroundColor:
                                    const Color.fromARGB(255, 186, 144, 198),
                                onPressed: _showImageSourceActionSheet,
                                child:
                                    const Icon(Icons.edit, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    );
                  },
                  onSaved: (newValue) {
                    imageFile = newValue;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Essa roupa combina mais com:'),
                FormField<List<String>>(
                  initialValue: _selectedTags,
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.0,
                          children: _tags.map((tag) {
                            final isSelected = _selectedTags.contains(tag);
                            return ChoiceChip(
                              label: Text(tag),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  isSelected
                                      ? _selectedTags.remove(tag)
                                      : _selectedTags.add(tag);
                                  state.didChange(_selectedTags);
                                });
                              },
                              selectedColor:
                                  const Color.fromARGB(255, 186, 144, 198),
                              backgroundColor: Colors.grey[200],
                            );
                          }).toList(),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione pelo menos uma categoria.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    if (newValue != null) {
                      _selectedTags.clear();
                      _selectedTags.addAll(newValue);
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text('Se preferir, dê um apelido à sua peça'),
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Apelido',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um apelido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 186, 144, 198),
                  ),
                  onPressed: _addClothes,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
