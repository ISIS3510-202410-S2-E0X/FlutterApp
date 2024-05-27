import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class ServiceAdapterSearchWords {
  String toJson(String searchWord) {
    return jsonEncode({'terms': [searchWord]});
  }

  Future<void> postDataToFirestore(String searchWord) async {
    final jsonString = toJson(searchWord);
    try {
      await FirebaseFirestore.instance.collection('searchTerms').add(json.decode(jsonString));
      print('Data posted successfully!');
    } catch (e) {
      print('Error posting data: $e');
    }
  }
}
