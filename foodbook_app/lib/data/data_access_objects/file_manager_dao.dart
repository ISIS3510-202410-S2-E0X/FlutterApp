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


  Future<void> saveImage(File imageFile, String imageName) async {
  final file = await _localFile(imageName);
  // Write the file
  await file.writeAsBytes(imageFile.readAsBytesSync());
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