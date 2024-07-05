import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/navigation_page.dart';
import 'package:flutter_app/pages/sign_up_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color.fromARGB(255, 48, 25, 52), Color.fromARGB(255, 251, 174, 210)]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _icon(),
              const SizedBox(height: 50),
              _inputField("Usuário", usernameController),
              const SizedBox(height: 25),
              _inputField("Senha", password, isPassword: true),
              const SizedBox(height: 50),
              _loginButton(),
              const SizedBox(height: 10),
              _signUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 120),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {bool isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

void signInUser() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: usernameController.text,
      password: password.text,
    );
  } catch (e) {
    // pra evitar ficar preso na exceção
  }
}
  Widget _loginButton() {
    return ElevatedButton(
      onPressed: () {
        signInUser();
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Entrar",
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 58, 25, 52),
          ),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      },
      child: Text(
        "Não possui uma conta? Cadastre-se",
        style: GoogleFonts.cinzel(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
