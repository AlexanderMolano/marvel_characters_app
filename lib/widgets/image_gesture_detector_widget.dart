import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvel_characters_app/data/models/characters_response.dart';
import 'package:marvel_characters_app/widgets/characters_modal.dart';

class ImageGestureDetectorWidget extends StatelessWidget {
  final Character character;
  final String image;

  ImageGestureDetectorWidget(
      {Key? key, required this.character, required this.image})
      : super(key: key) {
    imageCache.clear();
    imageCache.maximumSize = 100; // Tamaño máximo de la caché
    imageCache.maximumSizeBytes = 100 << 20; // Tamaño máximo en bytes
  }

  //  {super.key, required this.character, required this.image});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (c) {
            return CharactersModal(
              character: character,
            );
          },
        );
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        color: colors.onError,
        elevation: 5.0,
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: image,
                width: width,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => Center(
                  child: Image.asset(
                    'assets/image/marvel.jpeg',
                    fit: BoxFit.fitHeight,
                    scale: 0.7,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Text(
                  character.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 12,
                      color: colors.error,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
