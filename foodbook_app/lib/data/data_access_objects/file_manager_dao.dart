import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManagerDAO {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String imageName) async {
  final path = await _localPath;
  // Customize the file name using the provided image name
  return File('$path/$imageName');
}


  Future<String> saveImage(File image, String spot) async {
  // Get the application documents directory.
  final directory = await getApplicationDocumentsDirectory();

  // Path for the 'review drafts' folder.
  final localpath = Directory('${directory.path}/review drafts');

  // Check if 'review drafts' directory exists, if not, create it.
  if (!await localpath.exists()) {
    await localpath.create(recursive: true);
  }

  // Define the file path for the new image.
  final String filePath = '${localpath.path}${spot}Draft.jpg';

  // Save the image to the file.
  await image.copy(filePath);

  // Return the file path where the image is saved.
  return filePath;
}

  Future<File?> getImage(String imageName) async {
  try {
    final file = await _localFile(imageName);
    // Check if the file exists
    if (await file.exists()) {
      return file;
    } else {
      print("Image file does not exist.");
      return null;
    }
  } catch (e) {
    print("Error while getting image: $e");
    return null;
  }
}
  
    Future<void> deleteImage(String imageName) async {
    try {
      final file = await _localFile(imageName);
      // Check if the file exists
      if (await file.exists()) {
        await file.delete();
      } else {
        print("Image file does not exist.");
      }
    } catch (e) {
      print("Error while deleting image: $e");
    }
    }

}