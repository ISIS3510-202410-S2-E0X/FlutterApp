import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/presentation/views/review_view/food_category_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Category Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) {
          final foodCategoryBloc = FoodCategoryBloc(3);
          // Si hay un evento inicial que necesitas agregar, puedes hacerlo así:
          // foodCategoryBloc.add(InitialFoodCategoryEvent());
          return foodCategoryBloc;
        },
        child: FoodCategorySelectionView(),
      ),
    );
  }
}
