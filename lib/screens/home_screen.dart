import 'package:flutter/material.dart';
import 'package:marvel_characters_app/views/characters_first_view.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home-screen';
  final int pageIndex;

  HomeScreen({Key? key, this.pageIndex = 0}) : super(key: key) {
    imageCache.clear();
    imageCache.maximumSize = 100; // Tamaño máximo de la caché
    imageCache.maximumSizeBytes = 100 << 20; // Tamaño máximo en bytes
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Marvel Characters',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.red,
      body: CharactersFirstView(),
    );
  }
}
