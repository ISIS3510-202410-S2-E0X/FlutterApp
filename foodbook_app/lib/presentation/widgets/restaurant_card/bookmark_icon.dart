import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class BookmarkIcon extends StatefulWidget {
  final Restaurant restaurant;
  final Function onBookmarkPressed;

  const BookmarkIcon({Key? key, required this.restaurant, required this.onBookmarkPressed}) : super(key: key);

  @override
  _BookmarkIconState createState() => _BookmarkIconState();
}

class _BookmarkIconState extends State<BookmarkIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        // Cambiar el ícono visualmente según el estado
        widget.restaurant.bookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      onPressed: () => widget.onBookmarkPressed(),
    );
  }
}

