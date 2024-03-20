import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/image_upload_bloc/image_upload_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/image_upload_bloc/image_upload_event.dart';
import 'package:foodbook_app/bloc/review_bloc/image_upload_bloc/image_upload_state.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_event.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_state.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_state.dart';
import 'package:foodbook_app/data/dtos/review_dto.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';
import 'package:foodbook_app/presentation/views/restaurant_view/browse_view.dart';
import 'package:image_picker/image_picker.dart';

String _formatCurrentDate() {
  DateTime now = DateTime.now().toUtc().subtract(Duration(hours: 5));
  int hour = now.hour % 12;
  hour = hour == 0 ? 12 : hour;

  String period = now.hour >= 12 && now.hour < 24 ? 'p.m.' : 'a.m.';

  return '${now.day} de ${_getMonthName(now.month)} de ${now.year}, '
         '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} '
         '$period UTC-5';
}

String _getMonthName(int month) {
  const monthsInSpanish = [
    'january', 'february', 'march', 'april', 'may', 'june',
    'july', 'august', 'september', 'october', 'november', 'december'
  ];
  return monthsInSpanish[month - 1];
}

class TextAndImagesView extends StatefulWidget {
  final Restaurant restaurant;

  const TextAndImagesView({super.key, required this.restaurant});

  @override
  _TextAndImagesViewState createState() => _TextAndImagesViewState();
}

class _TextAndImagesViewState extends State<TextAndImagesView> {
  File? _image;
  int _times = 0;
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

  String? _email;
  String? _uploadedImageUrl;
  Future saveImage() async {
    print('Saving image...');
    if (_image == null) return; 
    final imageUploadBloc = BlocProvider.of<ImageUploadBloc>(context);
    imageUploadBloc.add(ImageUploadRequested(_image!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Leave a comment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => {
              context.read<UserBloc>().add(GetCurrentUser()),
              saveImage(),
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return BlocProvider<BrowseBloc>(
                    create: (context) =>
                        BrowseBloc(restaurantRepository: RestaurantRepository())
                          ..add(LoadRestaurants()),
                    child: BrowseView(),
                  );
                }),
              ),
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        elevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is AuthenticatedUserState) {
                _email = state.email;
                if (_image == null && _times == 0) {
                  print('No image to upload, creating review...');
                  createReview(_email!, null);
                }
              } else if (state is UnauthenticatedUserState) {
                print('Usuario no autenticado. Por favor, inicia sesión.');
              }
            },
          ),
          BlocListener<ImageUploadBloc, ImageUploadState>(
            listener: (context, state) {  
              if (state is ImageUploadSuccess) {
                _uploadedImageUrl = state.imageUrl;
                if (context.read<UserBloc>().state is AuthenticatedUserState && _times == 0) {
                  print('NO DEBERÍA ENTRAR ACÁ');
                  createReview(_email!, _uploadedImageUrl!);
                }
              } else if (state is ImageUploadFailure) {
                // Manejo del error
                print('Error al subir imagen: ${state.error}');
              }
            },
          ),
        ],
        child: buildForm(),
      ),
    );
  }

  Widget buildForm() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
                  child: Text(
                    'Write what you thought of the restaurant! (add some images to show your experience!)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _titleController,
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
                    controller: _commentController,
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
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : const Icon(Icons.camera_alt, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlinedButton(
                    onPressed: getImage,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
    );
  }

  void createReview(String userEmail, String? uploadedImageUrl) async {
    print('HOLA ME LLAMARON');
    final foodCategoryBloc = BlocProvider.of<FoodCategoryBloc>(context);
    final starsBloc = BlocProvider.of<StarsBloc>(context);

    final selectedCategories = foodCategoryBloc.selectedCategories;
    final stars = starsBloc.newRatings;

    final selectedCategoriesString = selectedCategories.map((category) => category.name).toList();
    print('MIRA MIRA ESTO: $uploadedImageUrl');
    ReviewDTO newReview = ReviewDTO(
      user: userEmail.replaceFirst("@gmail.com", ""),
      title: _titleController.text,
      content: _commentController.text,
      date: _formatCurrentDate(),
      imageUrl: uploadedImageUrl,
      ratings: stars,
      selectedCategories: selectedCategoriesString,
    );

    try {
      print('Creating review...');
      BlocProvider.of<ReviewBloc>(context).add(CreateReviewEvent(newReview, widget.restaurant.name));
      _resetFormAndImage();
      _times = 1;
      // TO-DO: show a success message
    } catch (e) {
      // TO-DO: show an error message
    }
  }

  void _resetFormAndImage() {
    _titleController.clear();
    _commentController.clear();
    _image = null; // Asegúrate de que la imagen se resetea correctamente
    _uploadedImageUrl = null; // Resetear la URL de la imagen subida
    setState(() {
      _image = null; // Asegúrate de que la imagen se resetea correctamente
      _uploadedImageUrl = null; // Resetear la URL de la imagen subida
    });
  }
}
