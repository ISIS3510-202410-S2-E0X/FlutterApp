import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:foodbook_app/presentation/views/review_view/categories_stars_view.dart';

class TextAndImagesView extends StatefulWidget {
  const TextAndImagesView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TextAndImagesViewState createState() => _TextAndImagesViewState();
}

class _TextAndImagesViewState extends State<TextAndImagesView> {
  File? _image;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 10),
                  child: Text(
                    'Leave a comment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
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
                        hintText: 'Optional',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      height: 200,
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
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                          color: Color.fromRGBO(0, 122, 255 , 100), // Corrección en la opacidad
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100.0),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Back to categories and stars',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(0, 122, 255 , 100),
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
