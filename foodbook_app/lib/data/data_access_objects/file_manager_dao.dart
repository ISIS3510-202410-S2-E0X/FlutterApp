import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManagerDAO {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    // You can customize the file name here as per your requirement
    return File('$path/image.png');
  }

  Future<void> saveImage(File imageFile) async {
    final file = await _localFile;
    // Write the file
    await file.writeAsBytes(imageFile.readAsBytesSync());
  }

  Future<File?> getImage() async {
  try {
    final file = await _localFile;
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

}
