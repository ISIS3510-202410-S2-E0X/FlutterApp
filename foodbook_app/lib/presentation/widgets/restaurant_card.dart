import 'package:flutter/material.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SizedBox(
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: restaurant.imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(restaurant.imageUrls[index]);
              },
            ),
          ),
          ListTile(
            title: Text(restaurant.name),
            subtitle: Text('${restaurant.waitTime} · ${restaurant.distance}'),
            trailing: Icon(Icons.bookmark_border),
          ),
          Wrap(
            children: restaurant.tags.map((tag) => Chip(label: Text(tag))).toList(),
          ),
        ],
      ),
    );
  }
}
