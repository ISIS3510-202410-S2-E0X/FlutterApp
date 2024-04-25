import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_bloc.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_event.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_state.dart';
import 'package:foodbook_app/data/data_sources/database_provider.dart';
import 'package:foodbook_app/data/repositories/reviewdraft_repository.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';
import 'package:foodbook_app/presentation/views/spot_infomation_view/spot_detail_view.dart';
import 'package:foodbook_app/presentation/widgets/menu/navigation_bar.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/restaurant_card.dart';

class ForYouView extends StatefulWidget {
  const ForYouView({super.key});

  @override
  State<ForYouView> createState() => _ForYouViewState();
}

class _ForYouViewState extends State<ForYouView> {
  @override
  void initState() {
    super.initState();
    // Solicita el usuario actual tan pronto como el widget se inicialice.
    BlocProvider.of<UserBloc>(context, listen: false).add(GetCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookmarkBloc>(
      create: (context) => BookmarkBloc(
        BookmarkManager(), 
      ),
      child:PopScope(
      canPop: false,
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is AuthenticatedUserState) {
                BlocProvider.of<BrowseBloc>(context).add(FetchRecommendedRestaurants(state.email.replaceFirst("@gmail.com", "")));
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: const Text(
              'For You',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            elevation: 10,
          ),
          backgroundColor: Colors.grey[200],
          body: Column(
            children: [
              Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              Expanded(
                child: BlocBuilder<BrowseBloc, BrowseState>(
                  builder: (context, state) {
                    if (state is RestaurantsLoadInProgress) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RestaurantsRecommendationLoadSuccess) {
                      if (state.recommendedRestaurants.isEmpty) {
                        return const Center(child: Text('No restaurants to show'));
                      }
                      return ListView.builder(
                        itemCount: state.recommendedRestaurants.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<ReviewDraftBloc>(
                                        create: (context) => ReviewDraftBloc(
                                          RepositoryProvider.of<ReviewDraftRepository>(context)
                                        ),
                                      ),
                                    ],
                                    child: SpotDetail(restaurantId: state.recommendedRestaurants[index].id),
                                  ),
                                ),
                              );
                            },
                            child: RestaurantCard(restaurant: state.recommendedRestaurants[index]),
                          );
                        },
                      );
                    } else if (state is RestaurantsLoadFailure) {
                        return Center(
                        child: Text(
                          state.error.toString().replaceAll('Exception:', ''),
                          textAlign: TextAlign.center,
                        ),
                        );

                    }
                    return const Center(child: Text('No restaurants to show'));
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomNavigationBar(
            selectedIndex: 1,
            onItemTapped: (int index) {
              if (index == 0) {
                Navigator.pushNamed(context, '/browse');
              } else if (index == 2) {
                Navigator.pushNamed(context, '/bookmarks');
              }
            },
          )),
        )
      ),
    );
  }
}
