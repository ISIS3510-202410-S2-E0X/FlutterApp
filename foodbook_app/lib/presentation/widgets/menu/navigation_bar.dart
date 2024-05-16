import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';
import 'package:foodbook_app/presentation/views/restaurant_view/bookmarks_view.dart';
import 'package:foodbook_app/presentation/views/restaurant_view/browse_view.dart';
import 'package:foodbook_app/presentation/views/restaurant_view/for_you_view.dart';


class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          label: 'For You',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Bookmarks'),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: (index) {
        
        if (index == 0) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<BrowseBloc>(
                  create: (context) => BrowseBloc(restaurantRepository: RestaurantRepository(), reviewRepository: ReviewRepository())..add(LoadRestaurants()),         
                ),
                 BlocProvider<BookmarkInternetViewBloc>(
                  create: (context) => BookmarkInternetViewBloc(),
                )
              ],
              child: BrowseView(),
            ),
          ));
        } else if (index == 1) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<BrowseBloc>(
                  create: (context) => BrowseBloc(restaurantRepository: RestaurantRepository(), reviewRepository: ReviewRepository()),
                ),
                BlocProvider<UserBloc>(
                  create: (context) => UserBloc(),
                ),
                BlocProvider<BookmarkInternetViewBloc>(
                  create: (context) => BookmarkInternetViewBloc(),
                )
              ],
              child: ForYouView(),
            ),
          ));
        } else if (index == 2) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<BookmarkViewBloc>(
                    create: (context) => BookmarkViewBloc(
                      bookmarkManager: BookmarkManager(),
                      restaurantRepository: RestaurantRepository(),
                    ),
                  ),
                  BlocProvider<BookmarkInternetViewBloc>(
                    create: (context) => BookmarkInternetViewBloc(),
                  ),
                ],
                child: const BookmarksView(),
              ),
            ),
          );
        }
      },
    );
  }
}