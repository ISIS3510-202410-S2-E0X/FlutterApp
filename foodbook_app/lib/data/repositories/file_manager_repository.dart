import 'dart:io';
import 'package:foodbook_app/data/data_access_objects/file_manager_dao.dart';


class FileManagerRepository {
  final FileManagerDAO _fileManagerDAO;

  FileManagerRepository(this._fileManagerDAO);

  Future<void> saveImage(File imageFile, String imageName) async {
    await _fileManagerDAO.saveImage(imageFile, imageName);
  }

  Future<File?> getImage(String imageName) async {
    return await _fileManagerDAO.getImage(imageName);
  }

  Future<void> deleteImage(String imageName) async {
    await _fileManagerDAO.deleteImage(imageName);
  }
}
