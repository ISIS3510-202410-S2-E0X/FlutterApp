import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/presentation/views/review_view/review_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        child: CreateReviewView(),
      ),
    );
  }
}
