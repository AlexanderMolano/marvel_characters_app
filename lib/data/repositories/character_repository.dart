import 'package:http/http.dart' as http;
import 'package:marvel_characters_app/data/models/characters_response.dart';
import 'dart:convert';

import 'package:marvel_characters_app/utils/environment.dart';

class CharacterRepository {
  List<Character> characters = [];
  int offset = 0;
  int limit = 100;
  bool loading = false;

  Future<void> fetchCharacters() async {
    if (loading) return; // Evita llamar a la función mientras ya está cargando

    loading = true;

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
      characters.addAll(data.data.characters);
      offset += limit;
      loading = false;

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
    characters = searchResult;
  }
}
