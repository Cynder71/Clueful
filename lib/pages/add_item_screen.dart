import 'package:flutter/material.dart';
import 'package:flutter_app/pages/add_form.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'add_form.dart'; // Importe a página AddClothes

class ChoicePage extends StatelessWidget {
  const ChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 221, 207),
      appBar: AppBar(
        title: Text(
          'Escolha o que deseja',
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:const Color.fromARGB(255, 58, 25, 52),
                  minimumSize: const Size(150, 150),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddItem()),
                  );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.checkroom, 
                      size: 50,
                      color: Color.fromARGB(255, 241, 221, 207),
                      ),
                    SizedBox(height: 8),
                    Text(
                      'Adicionar roupa',
                      style: TextStyle(color: Color.fromARGB(255, 241, 221, 207)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 58, 25, 52),
                  minimumSize: const Size(150, 150),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddItem()),
                  );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                     Icons.star,
                     size: 50,
                     color: Color.fromARGB(255, 241, 221, 207),
                     ),
                    SizedBox(height: 8),
                    Text(
                      'Adicionar look',
                      style: TextStyle(color: Color.fromARGB(255, 241, 221, 207)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
