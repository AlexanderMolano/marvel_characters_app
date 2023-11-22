import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marvel_characters_app/data/models/characters_response.dart';
import 'package:marvel_characters_app/utils/environment.dart';
import 'package:marvel_characters_app/views/characters_view.dart';

class CharacterRepository {
  int pageSize = 20;
  int totalResults = 0;
  int offset = 0;
  bool loading = false;
  List<Character> characters = [];
  CharactersView view;
  final String numberOffset;

  CharacterRepository(this.view, this.numberOffset);

  void fetchCharacters() async {
    if (loading) return;

    loading = true;

    final uri = Uri(
      scheme: 'http',
      host: BaseUrl.httpBaseUrl,
      path: BaseUrl.charactersPath,
      queryParameters: {
        'apikey': Environment.marvelDbKey,
        'hash': Environment.marvelHash,
        'ts': Environment.marvelTS,
        'limit': pageSize.toString(),
        'offset': offset.toString(),
      },
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        totalResults = decodedData['data']['total'];
        List<Character> newCharacters =
            CharactersResponse.fromJson(decodedData).data.characters;

        view.addItems(newCharacters);
        characters.addAll(newCharacters);

        if (characters.length < totalResults) {
          offset += pageSize;
        }

        view.hideLoading();
      } else if (response.statusCode == 404) {
        throw Exception('No se encontraron personajes');
      } else {
        throw Exception(
            'Error desconocido al cargar personajes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching characters: $e');
      view.showErrorMessage('Error al cargar personajes');
    } finally {
      loading = false;
    }
  }

  List<Character> searchCharacters(String query) {
    return characters
        .where((character) =>
            character.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void refresh() {
    characters.clear(); // Puedes ajustar esto según tu lógica de recarga
    offset = 0;
    fetchCharacters();
  }
}
