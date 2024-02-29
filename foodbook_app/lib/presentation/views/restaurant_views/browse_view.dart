import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card.dart';

class BrowseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrowseBloc>(
      create: (_) => BrowseBloc()..add(LoadRestaurantsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Browse'),
          // Add other AppBar properties as needed
        ),
        body: BlocBuilder<BrowseBloc, BrowseState>(
          builder: (context, state) {
            if (state is BrowseLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BrowseLoadSuccess) {
              return ListView.builder(
                itemCount: state.restaurants.length,
                itemBuilder: (context, index) {
                  return RestaurantCard(restaurant: state.restaurants[index]);
                },
              );
            } else if (state is BrowseLoadFailure) {
              return Center(child: Text('Failed to load restaurants'));
            } else {
              return Center(child: Text('Please wait...'));
            }
          },
        ),
        // Add other Scaffold properties as needed
      ),
    );
  }
}
