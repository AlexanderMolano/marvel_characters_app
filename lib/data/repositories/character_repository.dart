import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marvel_characters_app/data/models/characters_response.dart';
import 'package:marvel_characters_app/utils/environment.dart';
import 'package:marvel_characters_app/views/characters_view.dart';

class CharacterRepository {
  List<Character> characters = [];
  final itemsPerPage = 20;
  int offset = 0;
  int limit = 100;
  int page = 0;
  var lastTotalReturnedItems = 0;
  bool loading = false;
  CharactersView view;
  var firstCall = true;

  CharacterRepository(this.view);

  void fetchCharacters() async {
    if (loading) return; // Evita llamar a la función mientras ya está cargando

    loading = true;

    final uri = Uri(
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
    );

    if (!firstCall) {
      if (lastTotalReturnedItems < itemsPerPage) {
        List<Character> character = [];
        view.addItems(character);
      }
    }

    view.showLoading();
    firstCall = false;

    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        characters = CharactersResponse.fromJson(decodedData).data.characters;
        lastTotalReturnedItems = characters.length;
        page++;
        view.addItems(characters);
        view.hideLoading();

        // characters.addAll(characters);
        // offset += limit;
        // loading = false;

        // Si hay más personajes, continúa recuperando

        print(characters.first.name);
      } else {
        throw Exception('Failed to load characters');
      }
    });
  }

  void searchCharacters(String query) {
    List<Character> searchResult = characters
        .where((character) =>
            character.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    // Actualiza la lista de personajes con los resultados de la búsqueda
    characters = searchResult;
  }

  void refresh() {
    limit = 0;
    offset = 0;

    //firstCall = true;
    //searchTerm = "";
    view.clearList();
  }
}
