import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvel_characters_app/data/models/characters_response.dart';

class CharactersModal extends StatefulWidget {
  final Character character;
  const CharactersModal({super.key, required this.character});

  @override
  State<CharactersModal> createState() => _CharactersModalState();
}

class _CharactersModalState extends State<CharactersModal>
//implements CharactersDetailsView
{
  //late CharactersDetailPresenter presenter;
  late Character character;

  List<Character> comics = [];

  final TextEditingController editTextController = TextEditingController();
  var isLoading = false;
  final ScrollController scrollController = ScrollController();
  int currentPageNumber = 0;

  @override
  void initState() {
    super.initState();
    character = widget.character;
    //presenter = CharactersDetailPresenter(this, character.id);
    //presenter.getComics();
    print(character.id);
  }

  @override
  Widget build(BuildContext context) {
    final description = character.description.isEmpty
        ? "This character doesn't have a description"
        : character.description;

    final height = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    character.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black87,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl:
                        "${character.thumbnail.path}.${character.thumbnail.extension}",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                    child: Text(
                      description,
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  addItems(List<Character> comics) {
    setState(() {
      this.comics.addAll(comics);
    });
  }

  @override
  clearList() {
    setState(() {
      comics.clear();
      editTextController.clear();
    });
  }

  @override
  hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  showError() {
    print('Error al cargar el comic');
  }

  @override
  showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  bool onNotification(ScrollNotification notification) {
    print("Notification");

    if (notification is ScrollUpdateNotification) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (!isLoading) {
          //presenter.getComics();
        }
      }
    }

    return true;
  }
}
