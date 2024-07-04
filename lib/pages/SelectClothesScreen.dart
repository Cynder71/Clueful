//Código com canvas
/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:flutter_app/pages/CreateOutfitScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectClothesScreen extends StatefulWidget {
  final Key? key;

  const SelectClothesScreen({this.key}) : super(key: key);

  @override
  SelectClothesScreenState createState() => SelectClothesScreenState();
}

class SelectClothesScreenState extends State<SelectClothesScreen> {
  List<Item> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        title: Text(
          'Selecione Roupas',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 58, 25, 52),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
              bool isSelected = selectedItems.contains(item);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedItems.remove(item);
                    } else {
                      selectedItems.add(item);
                    }
                  });
                },
                child: Stack(
                  children: [
                    Card(
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
                    if (isSelected)
                      const Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.check_circle, color: Colors.purple),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 58, 25, 52),
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateOutfitScreen(selectedItems: selectedItems),
            ),
          );
        },
      ),
    );
  }
}*/

//Código com carrossel
/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/pages/CreateOutfitScreen.dart';

class SelectClothesScreen extends StatefulWidget {
  final Key? key;

  const SelectClothesScreen({this.key}) : super(key: key);

  @override
  SelectClothesScreenState createState() => SelectClothesScreenState();
}

class SelectClothesScreenState extends State<SelectClothesScreen> {
  List<String> selectedItemsIds = [];
  List<Item> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
          title: Text(
            'Selecione Roupas',
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
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          items = snapshot.data!.docs.map((doc) {
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
              bool isSelected = selectedItemsIds.contains(item.id);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedItemsIds.remove(item.id);
                    } else {
                      selectedItemsIds.add(item.id);
                    }
                  });
                },
                child: Stack(
                  children: [
                    Card(
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
                    if (isSelected)
                      const Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.check_circle,
                            color: Color.fromARGB(255, 224, 33, 122)),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 58, 25, 52),
        child: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 241, 221, 207),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateOutfitScreen(
                  selectedItems: selectedItemsIds.map((id) {
                return items.firstWhere((item) => item.id == id);
              }).toList()),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/pages/CreateOutfitScreen.dart';

class SelectClothesScreen extends StatefulWidget {
  final List<String> initialSelectedItems;

  const SelectClothesScreen({Key? key, required this.initialSelectedItems})
      : super(key: key);

  @override
  SelectClothesScreenState createState() => SelectClothesScreenState();
}

class SelectClothesScreenState extends State<SelectClothesScreen> {
  List<String> selectedItemsIds = [];
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    selectedItemsIds = widget.initialSelectedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        title: Text(
          'Selecione Roupas',
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          items = snapshot.data!.docs.map((doc) {
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
              bool isSelected = selectedItemsIds.contains(item.id);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedItemsIds.remove(item.id);
                    } else {
                      selectedItemsIds.add(item.id);
                    }
                  });
                },
                child: Stack(
                  children: [
                    Card(
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
                    if (isSelected)
                      const Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.check_circle,
                            color: Color.fromARGB(255, 224, 33, 122)),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 58, 25, 52),
        child: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 241, 221, 207),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateOutfitScreen(
                selectedItems: selectedItemsIds.map((id) {
                  return items.firstWhere((item) => item.id == id);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/pages/CreateOutfitScreen.dart';
import 'package:flutter_app/pages/look_detail_screen.dart';
import 'package:flutter_app/backend/OutfitController.dart'; 
import 'package:flutter_app/models/Outfit.dart';

class SelectClothesScreen extends StatefulWidget {
  final List<String>? initialSelectedItems;
  final String origin;

  const SelectClothesScreen({Key? key, this.initialSelectedItems, required this.origin})
      : super(key: key);

  @override
  SelectClothesScreenState createState() => SelectClothesScreenState();
}

class SelectClothesScreenState extends State<SelectClothesScreen> {
  List<String> selectedItemsIds = [];
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    selectedItemsIds = widget.initialSelectedItems ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        title: Text(
          'Selecione Roupas',
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          items = snapshot.data!.docs.map((doc) {
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
              bool isSelected = selectedItemsIds.contains(item.id);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedItemsIds.remove(item.id);
                    } else {
                      selectedItemsIds.add(item.id);
                    }
                  });
                },
                child: Stack(
                  children: [
                    Card(
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
                    if (isSelected)
                      const Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.check_circle,
                            color: Color.fromARGB(255, 224, 33, 122)),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 58, 25, 52),
        child: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 241, 221, 207),
        ),
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateOutfitScreen(
                selectedItems: selectedItemsIds.map((id) {
                  return items.firstWhere((item) => item.id == id);
                }).toList(),
              ),
            ),
          );*/
           if (widget.origin == 'ChoicePage') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateOutfitScreen(
                  selectedItems: selectedItemsIds.map((id) {
                    return items.firstWhere((item) => item.id == id);
                  }).toList(),
                ),
              ),
            );
          } else if (widget.origin == 'EditOutfitScreen') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditOutfitScreen(
                  outfit: ,
                ),
              ),
            );          }
        },
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Item.dart';
import 'package:flutter_app/models/Outfit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/pages/CreateOutfitScreen.dart';
import 'package:flutter_app/pages/look_detail_screen.dart'; // Adicionei a importação para EditOutfitScreen

class SelectClothesScreen extends StatefulWidget {
  final List<String>? initialSelectedItems;
  final String origin;
  final Outfit?
      outfit; // Adicionei a variável outfit para passar o outfit atual

  const SelectClothesScreen({
    Key? key,
    this.initialSelectedItems,
    required this.origin,
    this.outfit, // Adicionei o outfit ao construtor
  }) : super(key: key);

  @override
  SelectClothesScreenState createState() => SelectClothesScreenState();
}

class SelectClothesScreenState extends State<SelectClothesScreen> {
  List<String> selectedItemsIds = [];
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    selectedItemsIds = widget.initialSelectedItems ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        title: Text(
          'Selecione Roupas',
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          items = snapshot.data!.docs.map((doc) {
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
              bool isSelected = selectedItemsIds.contains(item.id);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedItemsIds.remove(item.id);
                    } else {
                      selectedItemsIds.add(item.id);
                    }
                  });
                },
                child: Stack(
                  children: [
                    Card(
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
                    if (isSelected)
                      const Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.check_circle,
                            color: Color.fromARGB(255, 224, 33, 122)),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 58, 25, 52),
        child: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 241, 221, 207),
        ),
        onPressed: () {
          if (widget.origin == 'ChoicePage') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateOutfitScreen(
                  selectedItems: selectedItemsIds.map((id) {
                    return items.firstWhere((item) => item.id == id);
                  }).toList(),
                ),
              ),
            );
          } else if (widget.origin == 'EditOutfitScreen') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditOutfitScreen(
                  outfit: widget.outfit!, // Passa o outfit atual
                  selectedItems: selectedItemsIds.map((id) {
                    return items.firstWhere((item) => item.id == id);
                  }).toList(), // Passa os itens selecionados
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
