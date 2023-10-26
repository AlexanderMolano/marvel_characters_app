class CharactersResponse {
  final Data data;

  CharactersResponse({required this.data});

  factory CharactersResponse.fromJson(Map<String, dynamic> json) =>
      CharactersResponse(data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"data": data};
}

class Data {
  int offset;
  int limit;
  int total;
  int count;
  List<Character> characters;

  Data({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.characters,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      offset: json['offset'],
      limit: json['limit'],
      total: json['total'],
      count: json['count'],
      characters: List<Character>.from(
          json['results'].map((x) => Character.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "limit": limit,
        "total": total,
        "count": count,
        "results": List<dynamic>.from(characters.map((x) => x.toJson())),
      };
}

class Character {
  int id;
  String name;
  String description;
  Thumbnail thumbnail;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        thumbnail: Thumbnail.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}

class Thumbnail {
  String path;
  String extension;

  Thumbnail({
    required this.path,
    required this.extension,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        path: json["path"],
        extension: json["extension"],
        //extension: extensionValues.map[json["extension"]]!,
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "extension": extension,
        // "extension": extensionValues.reverse[extension],
      };
}
