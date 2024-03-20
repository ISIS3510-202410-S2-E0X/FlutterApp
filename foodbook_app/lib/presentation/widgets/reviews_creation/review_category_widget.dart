import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_event.dart';

class RatingCategory extends StatelessWidget {
  final String category;
  final double initialRating;

  const RatingCategory({super.key, required this.category, required this.initialRating});

  String toCamelCase(String str) {
    List<String> words = str.split(' ');

    for (int i = 1; i < words.length; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }

    String result = words.join('');

    return result[0].toLowerCase() + result.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color.fromARGB(192, 217, 219, 225),
      child: Row(
        children: [
          Expanded(
            child: Text(category, style: const TextStyle(fontSize: 15)),
          ),
          RatingBar.builder(
            initialRating: initialRating,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            // textDirection: TextDirection.rtl,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Color.fromARGB(255, 22, 49, 255),
              size: 8,
            ),
            onRatingUpdate: (rating) {
              // Enviar evento al BLoC
              print('UPDATED!');
              context.read<StarsBloc>().add(ReviewRatingChanged(toCamelCase(category), rating));
            },
          ),
        ],
      ),
    );
  }
}
