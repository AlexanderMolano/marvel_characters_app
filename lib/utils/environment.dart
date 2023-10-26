import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String marvelDbKey = dotenv.env['MARVEL_KEY'] ?? 'No hay API Key';
  static String marvelHash = dotenv.env['HASH'] ?? 'No hay API Hash';
  static String marvelTS = dotenv.env['TS'] ?? 'No hay API TS';
  static String imagePath = dotenv.env['IMAGEPATH'] ?? 'No hay API IMAGEPATH';
}

class BaseUrl {
  static const baseUrl = 'https://gateway.marvel.com';
  static const comicsPath = '/v1/public/comics';
  static const httpBaseUrl = 'gateway.marvel.com';
  static const charactersPath = '/v1/public/characters';
}
