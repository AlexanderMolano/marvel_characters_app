import 'package:marvel_characters_app/data/models/characters_response.dart';

abstract class CharactersView {
  addItems(List<Character> characters);
  showLoading();
  hideLoading();
  clearList();
}
