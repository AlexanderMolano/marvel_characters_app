import 'package:flutter/material.dart';
import 'package:marvel_characters_app/data/models/characters_response.dart';
import 'package:marvel_characters_app/data/repositories/character_repository.dart';
import 'package:marvel_characters_app/views/characters_view.dart';
import 'package:marvel_characters_app/widgets/image_gesture_detector_widget.dart';

class HomeThirdhoffset extends StatefulWidget {
  HomeThirdhoffset({Key? key}) : super(key: key) {
    imageCache.clear();
    imageCache.maximumSize = 100; // Tamaño máximo de la caché
    imageCache.maximumSizeBytes = 100 << 20; // Tamaño máximo en bytes
  }

  @override
  State<HomeThirdhoffset> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeThirdhoffset>
    implements CharactersView {
  late CharacterRepository characterRepository;

  int offset = 0;
  int limit = 0;

  bool loading = false;
  List<Character> characters = [];
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    characterRepository = CharacterRepository(this, '199');
    characterRepository.fetchCharacters();
  }

  void searchCharacters(String query) {
    List<Character> searchResult = characterRepository.searchCharacters(query);
    setState(() {
      characters = searchResult;
    });
  }

  Future<void> refreshCharacters(int limit) async {
    setState(() {
      offset += 100; // Aumenta el límite según tus necesidades
      characterRepository.fetchCharacters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification,
      child: Column(
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
                controller: searchController,
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
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: characters.length + 1,
                    itemBuilder: (context, index) {
                      if (index == characters.length) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              characterRepository.refresh();
                            });
                          },
                          child: Center(
                            child: Container(),
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
                            character: characters[index], image: thumbnailUrl);
                        //_ListTileWidget(thumbnailUrl: thumbnailUrl, character: character);
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  addItems(List<Character> characters) {
    setState(() {
      this.characters.addAll(characters);
    });
  }

  @override
  showLoading() {
    setState(() {
      loading = true;
    });
  }

  @override
  hideLoading() {
    setState(() {
      loading = false;
    });
  }

  @override
  clearList() {
    setState(() {
      characters.clear();
      searchController.clear();
    });
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (!loading) {
          characterRepository.fetchCharacters();
        }
      }
    }
    return true;
  }

  prepareSearch() {
    characterRepository.searchCharacters(searchController.text);
  }
}
