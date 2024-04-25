import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_bloc.dart';
import 'package:foodbook_app/bloc/search_bloc/search_bloc.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_bloc.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_event.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/presentation/views/profile_view/profile_view.dart';
import 'package:foodbook_app/presentation/views/spot_infomation_view/spot_detail_view.dart';
import 'package:foodbook_app/presentation/views/test_views/search_test.dart';
import 'package:foodbook_app/presentation/widgets/menu/navigation_bar.dart';
import 'package:foodbook_app/presentation/widgets/menu/filter_bar.dart';
import 'package:foodbook_app/presentation/widgets/menu/search_bar.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/restaurant_card.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';



class BrowseView extends StatelessWidget {
  BrowseView({Key? key}) : super(key: key);

  final Connectivity _connectivity = Connectivity();
  Stream<List<ConnectivityResult>> get _connectivityStream => _connectivity.onConnectivityChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookmarkBloc>(
      create: (context) => BookmarkBloc(BookmarkManager()),
      child: StreamBuilder<ConnectivityResult>(
        stream: _connectivityStream.asyncExpand((results) => Stream.fromIterable(results)),
        builder: (context, snapshot) {
          bool isOffline = snapshot.data == ConnectivityResult.none || snapshot.connectionState == ConnectionState.none;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Browse',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.58,
                    height: kToolbarHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SearchPage2(browseBloc: BlocProvider.of<BrowseBloc>(context)),
                    ),
                  ),
                ],
              ),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle, color: Color.fromARGB(255, 0, 140, 255)),
                  onPressed: () {
                    context.read<UserBloc>().add(GetCurrentUser());
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileView()),
                    );
                  },
                ),
              ],
            ),
            backgroundColor: Colors.grey[200], // Set the background color to grey
            body: Column(
              children: [
                if (isOffline)
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.signal_wifi_off, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('Offline', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                Divider(
                  height: 1, // Height of the divider line
                  color: Colors.grey[300], // Color of the divider line
                ),
                Expanded(
                  child: BlocBuilder<BrowseBloc, BrowseState>(
                    builder: (context, state) {
                      if (state is RestaurantsLoadInProgress) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is RestaurantsLoadSuccess) {
                        return ListView.builder(
                          itemCount: state.restaurants.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: BlocProvider.of<ReviewDraftBloc>(context),
                                    child: SpotDetail(restaurantId: state.restaurants[index].id),
                                  ),
                                ),
                              );
                            },
                            child: RestaurantCard(restaurant: state.restaurants[index]),
                          );
                          },
                        );
                      } else if (state is RestaurantsLoadFailure) {
                        return const Center(child: Text('Failed to load restaurants'));
                      }
                      // If the initial state is RestaurantsInitial or any other unexpected state
                      return const Center(child: Text('Start browsing by applying some filters!'));
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: CustomNavigationBar(
              selectedIndex: 0, // Set the selected index to 1
              onItemTapped: (int index) {
                // Handle navigation to different views
                if (index == 1) {
                  Navigator.pushNamed(context, 'package:foodbook_app/presentation/views/restaurant_views/login_view.dart');
                } else if (index == 2) {
                  Navigator.pushNamed(context, '/bookmarks');
                }
              },
            ),
          );
        },
      ),
    );
  }
}



// class BrowseView extends StatelessWidget {
//   BrowseView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.white, // Set AppBar background to white
//           title: const Text(
//             'Browse',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black, // Title color
//             ),
//           ),
//           // Add the FilterBar widget to the AppBar
//           actions: [
//             //FilterBar(),
//           ],
//           elevation: 0, // Remove shadow
//         ),
//         backgroundColor: Colors.grey[200], // Set the background color to grey
//         body: Column(
//           children: [
            
//             SearchPage2( browseBloc: BlocProvider.of<BrowseBloc>(context)),
//             Divider(
//               height: 1, // Height of the divider line
//               color: Colors.grey[300], // Color of the divider line
//             ),
//             Expanded(
//               child: BlocBuilder<BrowseBloc, BrowseState>(
//                 builder: (context, state) {
//                   if (state is RestaurantsLoadInProgress) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is RestaurantsLoadSuccess) {
//                     return ListView.builder(
//                       itemCount: state.restaurants.length,
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             // Navigate to another view when the restaurant card is clicked
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SpotDetail(restaurant: state.restaurants[index]),
//                               ),
//                             );
//                           },
//                           child: RestaurantCard(restaurant: state.restaurants[index]),
//                         );
//                       }
//                     );
//                   } else if (state is RestaurantsLoadFailure) {
//                     return const Center(child: Text('Failed to load restaurants'));
//                   }
//                   // Si el estado inicial es RestaurantsInitial o cualquier otro estado no esperado
//                   return const Center(child: Text('Start browsing by applying some filters!'));
//                 },
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: CustomNavigationBar(
//           selectedIndex: 0, // Set the selected index to 1
//           onItemTapped: (int index) {
//             // Handle navigation to different views
//             if (index == 1) {
//               Navigator.pushNamed(context, 'package:foodbook_app/presentation/views/restaurant_views/login_view.dart');
//             } else if (index == 2) {
//               Navigator.pushNamed(context, '/bookmarks');
//             }
//           },
//         ),
//       )
//     );
//   }
// }