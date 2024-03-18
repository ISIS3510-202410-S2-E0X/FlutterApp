import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
import 'package:foodbook_app/data/dtos/review_dto.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';
import 'package:foodbook_app/presentation/views/restaurant_view/browse_view.dart';
import 'package:image_picker/image_picker.dart';

class TextAndImagesView extends StatefulWidget {
  const TextAndImagesView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TextAndImagesViewState createState() => _TextAndImagesViewState();
}

class _TextAndImagesViewState extends State<TextAndImagesView> {
  File? _image;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  void createReview() async {
    // Accede al FoodCategoryBloc para obtener las categorías seleccionadas
    final foodCategoryBloc = BlocProvider.of<FoodCategoryBloc>(context);
    final selectedCategories = foodCategoryBloc.selectedCategories;

    final startBloc = BlocProvider.of<StarsBloc>(context);
    final stars = startBloc.newRatings;
    print('Selected categories: $selectedCategories');
    print('Stars: $stars');
    ReviewDTO newReview = ReviewDTO(
      user:
          "userID", // TO-DO: change to the actual user ID, you can get it from FirebaseAuth
      title: _titleController
          .text,
      content:
          _commentController.text,
      date: DateTime.now().toString(),
      imageUrl: _image
          ?.path, // TO-DO: upload the image to Firebase Storage and get the URL
      ratings: stars,
      selectedCategoriesDTOs: selectedCategories,
    );

    try {
      final reviewRepository = ReviewRepository();
      
      await reviewRepository.create(review: newReview);
      // TO-DO: show a success message to the user
    } catch (e) {
      // TO-DO: show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white, // Set AppBar background to white
        title: const Text(
          'Leave a comment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Title color
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              createReview();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return BlocProvider<BrowseBloc>(
                    create: (context) =>
                        BrowseBloc(restaurantRepository: RestaurantRepository())
                          ..add(LoadRestaurants()),
                    child: BrowseView(),
                  );
                }),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(0, 122, 255, 100),
              ),
            ),
          ),
        ],
        elevation: 0, // Remove shadow
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
                    child: Text(
                      'Write what you thought of the restaurant, and add some images to show your experience!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Comment',
                        hintText: 'Your review',
                      ),
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ) // Shows the image if it exists
                          : const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: OutlinedButton(
                      onPressed: getImage,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Add a photo',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(0, 122, 255, 100),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
