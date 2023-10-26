import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:marvel_characters_app/data/models/characters_response.dart';
import 'package:marvel_characters_app/utils/environment.dart';
import 'package:marvel_characters_app/widgets/image_gesture_detector_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key) {
    imageCache.clear();
    imageCache.maximumSize = 100; // Tamaño máximo de la caché
    imageCache.maximumSizeBytes = 100 << 20; // Tamaño máximo en bytes
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int offset = 0;
  int limit = 100;
  bool loading = false;
  List<Character> characters = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    setState(() {
      loading = true;
    });

    final response = await http.get(
      Uri(
        scheme: 'http',
        host: BaseUrl.httpBaseUrl,
        path: BaseUrl.charactersPath,
        queryParameters: {
          'apikey': Environment.marvelDbKey,
          'hash': Environment.marvelHash,
          'ts': Environment.marvelTS,
          "limit": limit.toString(),
          "offset": offset.toString(),
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final data = CharactersResponse.fromJson(jsonData);
      setState(() {
        characters.addAll(data.data.characters);
        offset += limit;
        loading = false;
      });

      // Si hay más personajes, continúa recuperando
      if (data.data.total > characters.length) {
        fetchCharacters();
      }
    } else {
      throw Exception('Failed to load characters');
    }
  }

  void searchCharacters(String query) {
    List<Character> searchResult = characters
        .where((character) =>
            character.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    // Actualiza la lista de personajes con los resultados de la búsqueda
    setState(() {
      characters = searchResult;
    });
  }

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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  searchCharacters(value);
                },
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                          style: BorderStyle.solid)),
                  labelText: 'Search',
                  hintText: 'Search characters by name...',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: loading
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset('assets/image/marvel.jpeg'))),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('The results will appear soon. Be patient ;)')
                    ],
                  ))
                : GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: .6,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: characters.length + 1,
                    itemBuilder: (context, index) {
                      if (index == characters.length) {
                        return GestureDetector(
                          onTap: fetchCharacters,
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * .6,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 5.0,
                                    spreadRadius: 2.0,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.black,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(
                                  "Load More",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            //Container(),
                          ),
                        );
                      } else {
                        final character = characters[index];

                        getThumbnailUrl(String variant) {
                          return '${character.thumbnail.path}/$variant.${character.thumbnail.extension}';
                        }

                        final thumbnailUrl =
                            getThumbnailUrl("portrait_incredible");
                        return ImageGestureDetectorWidget(
                            character: character, image: thumbnailUrl);
                        //_ListTileWidget(thumbnailUrl: thumbnailUrl, character: character);
                      }
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            characters.clear();
            offset = 0;
            fetchCharacters();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
