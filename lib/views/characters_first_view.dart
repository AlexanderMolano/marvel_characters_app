// import 'package:flutter/material.dart';
// import 'package:marvel_characters_app/data/models/characters_response.dart';
// import 'package:marvel_characters_app/data/repositories/character_repository.dart';
// import 'package:marvel_characters_app/views/characters_view.dart';
// import 'package:marvel_characters_app/widgets/image_gesture_detector_widget.dart';
// import 'package:marvel_characters_app/widgets/message_utils.dart';

// class CharactersFirstView extends StatefulWidget {
//   CharactersFirstView({Key? key}) : super(key: key) {
//     imageCache.clear();
//     imageCache.maximumSize = 100; // Tamaño máximo de la caché
//     imageCache.maximumSizeBytes = 100 << 20; // Tamaño máximo en bytes
//   }

//   @override
//   State<CharactersFirstView> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<CharactersFirstView>
//     implements CharactersView {
//   late CharacterRepository characterRepository;

//   int offset = 0;
//   int limit = 0;

//   bool loading = false;
//   List<Character> characters = [];
//   final TextEditingController searchController = TextEditingController();
//   final ScrollController scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     characterRepository = CharacterRepository(this, '0');
//     characterRepository.fetchCharacters();
//   }

//   void searchCharacters(String query) {
//     List<Character> searchResult = characterRepository.searchCharacters(query);
//     setState(() {
//       characters = searchResult;
//     });
//   }

//   Future<void> refreshCharacters(int limit) async {
//     setState(() {
//       offset += 20; // Aumenta el límite según tus necesidades
//       characterRepository.refresh();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return NotificationListener(
//       onNotification: onNotification,
//       child: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: TextField(
//                 controller: searchController,
//                 onChanged: (value) {
//                   searchCharacters(value);
//                 },
//                 decoration: InputDecoration(
//                   floatingLabelBehavior: FloatingLabelBehavior.never,
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                           color: Colors.red,
//                           width: 1,
//                           style: BorderStyle.solid)),
//                   labelText: 'Search',
//                   hintText: 'Search characters by name...',
//                   prefixIcon: const Icon(Icons.search),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: loading
//                 ? Center(
//                     child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const CircularProgressIndicator(
//                         color: Colors.black,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       SizedBox(
//                           width: MediaQuery.of(context).size.width * .8,
//                           child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.asset('assets/image/marvel.jpeg'))),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       const Text('The results will appear soon. Be patient ;)')
//                     ],
//                   ))
//                 : GridView.builder(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       childAspectRatio: .6,
//                       mainAxisSpacing: 4,
//                     ),
//                     controller: scrollController,
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     itemCount: characters.length + 1,
//                     itemBuilder: (context, index) {
//                       if (index == characters.length) {
//                         return loading
//                             ? const Center(
//                                 child: CircularProgressIndicator(
//                                   color: Colors.black,
//                                 ),
//                               )
//                             : GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     refreshCharacters(20);
//                                   });
//                                 },
//                                 child: Center(
//                                   child: Container(),
//                                 ),
//                               );
//                       } else {
//                         final character = characters[index];

//                         getThumbnailUrl(String variant) {
//                           return '${character.thumbnail.path}/$variant.${character.thumbnail.extension}';
//                         }

//                         final thumbnailUrl =
//                             getThumbnailUrl("portrait_incredible");

//                         return ImageGestureDetectorWidget(
//                             character: characters[index], image: thumbnailUrl);
//                         //_ListTileWidget(thumbnailUrl: thumbnailUrl, character: character);
//                       }
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   addItems(List<Character> characters) {
//     setState(() {
//       this.characters.addAll(characters);
//     });
//   }

//   @override
//   showLoading() {
//     setState(() {
//       loading = true;
//     });
//   }

//   @override
//   hideLoading() {
//     setState(() {
//       loading = false;
//     });
//   }

//   @override
//   clearList() {
//     setState(() {
//       characters.clear();
//       searchController.clear();
//     });
//   }

//   @override
//   showNoMoreItems(String s) {
//     return MessageUtils.showMessage(context, 'No more info', Colors.white);
//     //return 'No more info';
//   }

//   @override
//   showErrorMessage(String s) {
//     return MessageUtils.showMessage(context, 'No info about', Colors.white);
//     //return 'No info about';
//   }

//   bool onNotification(ScrollNotification notification) {
//     if (notification is ScrollUpdateNotification) {
//       if (scrollController.offset >=
//               scrollController.position.maxScrollExtent &&
//           !scrollController.position.outOfRange) {
//         if (!loading) {
//           characterRepository.fetchCharacters();
//         }
//       }
//     }
//     return true;
//   }

//   prepareSearch() {
//     characterRepository.searchCharacters(searchController.text);
//   }
// }
import 'package:flutter/material.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:marvel_characters_app/data/models/characters_response.dart';
import 'package:marvel_characters_app/data/repositories/character_repository.dart';
import 'package:marvel_characters_app/views/characters_view.dart';
import 'package:marvel_characters_app/widgets/image_gesture_detector_widget.dart';
import 'package:marvel_characters_app/widgets/message_utils.dart';

class CharactersFirstView extends StatefulWidget {
  CharactersFirstView({Key? key}) : super(key: key) {
    imageCache.clear();
    imageCache.maximumSize = 100; // Tamaño máximo de la caché
    imageCache.maximumSizeBytes = 100 << 20; // Tamaño máximo en bytes
  }

  @override
  State<CharactersFirstView> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CharactersFirstView>
    implements CharactersView {
  late CharacterRepository characterRepository;

  bool loading = false;
  List<Character> characters = [];
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    characterRepository = CharacterRepository(this, '0');
    characterRepository.fetchCharacters();
  }

  void searchCharacters(String query) {
    List<Character> searchResult = characterRepository.searchCharacters(query);
    setState(() {
      characters = searchResult;
    });
  }

  String getThumbnailUrl(String variant) {
    // Implementa la lógica para obtener la URL del thumbnail según el variant
    return '${characters.first.thumbnail.path}/$variant.${characters.first.thumbnail.extension}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marvel Characters'),
      ),
      body: PaginationView<Character>(
        preloadedItems: characters,
        itemBuilder: (BuildContext context, Character character, int index) {
          return ImageGestureDetectorWidget(
            character: character,
            image: getThumbnailUrl("portrait_incredible"),
          );
        },
        pageFetch: (int page) async {
          characterRepository.fetchCharacters();
          return characterRepository.characters;
        },
        paginationViewType: PaginationViewType.gridView,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.6,
          mainAxisSpacing: 4,
        ),
        bottomLoader: const CircularProgressIndicator(),
        pullToRefresh: true,
        onEmpty: const Center(
          child: Text('No characters available.'),
        ),
        onError: (dynamic error) => const Center(
          child: Text('Error loading characters.'),
        ),
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

  @override
  showNoMoreItems(String s) {
    MessageUtils.showMessage(context, 'No more info', Colors.white);
    //return 'No more info';
  }

  @override
  showErrorMessage(String s) {
    MessageUtils.showMessage(context, 'No info about', Colors.white);
    //return 'No info about';
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
