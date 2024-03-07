import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
// import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
// import 'package:foodbook_app/presentation/views/review_view/categories_stars_view.dart';
// import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
// import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
// import 'package:foodbook_app/data/repository/restaurant_repo.dart';
// import 'package:foodbook_app/presentation/views/restaurant_views/browse_view.dart';
import 'presentation/views/login_view/login_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
//<<<<<<< feature/4-browse-view
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Restaurant Browser',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
//      home: BlocProvider(
//        create: (context) => BrowseBloc(restaurantRepository: RestaurantRepository())
//          ..add(LoadRestaurants()), // Load restaurants when the app starts
//        child: BrowseView(),
//      ),
//    );
//  }
// }
//=======
  const MyApp({super.key});
/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Category Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<FoodCategoryBloc>(
            create: (context) => FoodCategoryBloc(3),
          ),
          BlocProvider<StarsBloc>(
            create: (context) => StarsBloc(),
          ),
        ],
        child: CategoriesAndStarsView(),
      ),
    );
  }
}
**/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: login_view(),
    );
  }

}
