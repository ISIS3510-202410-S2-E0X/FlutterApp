import 'dart:io';
import 'package:foodbook_app/data/data_access_objects/file_manager_dao.dart';


class FileManagerRepository {
  final FileManagerDAO _fileManagerDAO;

  FileManagerRepository(this._fileManagerDAO);

  Future<String> saveImage(File imageFile, String spotName) async {
    final savedPath = _fileManagerDAO.saveImage(imageFile, spotName);
    return savedPath;
  }

  Future<File?> getImage(String imageName) async {
    return await _fileManagerDAO.getImage(imageName);
  }

  Future<void> deleteImage(String imageName) async {
    await _fileManagerDAO.deleteImage(imageName);
  }
}