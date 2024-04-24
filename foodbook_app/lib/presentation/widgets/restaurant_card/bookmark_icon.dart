import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart'; // Replace with your actual path to BookmarkBloc
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_event.dart'; // Replace with your actual path to BookmarkEvent
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_state.dart'; // Replace with your actual path to BookmarkState

class BookmarkIcon extends StatefulWidget {
  final Restaurant restaurant;

  BookmarkIcon({Key? key, required this.restaurant}) : super(key: key);

  @override
  _BookmarkIconState createState() => _BookmarkIconState();
}

class _BookmarkIconState extends State<BookmarkIcon> {
  @override
  void initState() {
    super.initState();
    // Dispatch the CheckBookmark event as soon as the widget is inserted into the tree.
    BlocProvider.of<BookmarkBloc>(context, listen: false).add(CheckBookmark(widget.restaurant.id));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          bool isBookmarked = false;
          if (state is BookmarkLoaded) {
            isBookmarked = state.isBookmarked;
          }
          return Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Color.fromARGB(255, 0, 0, 0),
          );
        },
      ),
      onPressed: () {
        // Toggle the bookmark state when the icon button is pressed.
        BlocProvider.of<BookmarkBloc>(context).add(ToggleBookmark(widget.restaurant));
      },
    );
  }
}




