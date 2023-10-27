import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marvel_characters_app/data/models/characters_response.dart';
import 'package:marvel_characters_app/utils/environment.dart';
import 'package:marvel_characters_app/views/characters_view.dart';

class CharacterRepository {
  final itemsPerPage = 20;
  var lastTotalReturnedItems = 0;
  var firstCall = true;
  var searchTerm = "";
  int offset = 100;
  int limit = 100;
  int page = 0;
  bool loading = false;
  List<Character> characters = [];
  CharactersView view;
  final String numberOffset;

  CharacterRepository(this.view, this.numberOffset);

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
        "offset": numberOffset
        //offset.toString(),
      },
    );

    if (!firstCall) {
      if (limit < itemsPerPage) {
        List<Character> character = [];
        view.addItems(character);
      }
    }

    view.showLoading();
    firstCall = false;

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        characters = CharactersResponse.fromJson(decodedData).data.characters;
        lastTotalReturnedItems = characters.length;
        limit++;
        view.addItems(characters);
        view.hideLoading();

        // characters.addAll(characters);
        offset += limit;
        // loading = false;

        // Si hay más personajes, continúa recuperando

        print(characters.first.name);
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      print('Error fetching characters: $e');
    }
  }

  List<Character> searchCharacters(String query) {
    return characters
        .where((character) =>
            character.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void refresh() {
    offset += 20;
    fetchCharacters();
  }
}
