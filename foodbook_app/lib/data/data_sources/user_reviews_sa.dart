import 'package:cloud_firestore/cloud_firestore.dart';

class UserReviewsServiceAdapter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUserReviews(String username, String name) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('reviews')
          .where('user.id', isEqualTo: username)
          .where('user.name', isEqualTo: name)
          .get();

      List<Map<String, dynamic>> reviews = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return reviews;
    } catch (e) {
      print('Error fetching user reviews: $e');
      return [];
    }
  }
}
