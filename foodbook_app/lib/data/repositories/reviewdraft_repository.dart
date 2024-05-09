import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodbook_app/data/data_access_objects/file_manager_dao.dart';
import 'package:foodbook_app/data/dtos/reviewdraft_dto.dart';
import 'package:foodbook_app/data/models/reviewdraft.dart';
import 'package:foodbook_app/data/data_sources/database_provider.dart';

class ReviewDraftRepository {
  final DatabaseProvider dbProvider;
  final _fireCloud = FirebaseFirestore.instance.collection("unfinishedReviews");

  ReviewDraftRepository(this.dbProvider);

  Future<List<ReviewDraft>> getAllDrafts() async {
    final db = await dbProvider.getDatabase();
    var res = await db.query("ReviewDrafts");

    return res.isNotEmpty
        ? res.map((c) => ReviewDraftDTO.fromJson(c).toModel()).toList()
        : [];
  }

  Future<List<ReviewDraft>> getDraftsBySpot(String spot) async {
    await dbProvider.killDatabase();
    final db = await dbProvider.getDatabase();
    var res = await db.query(
      "ReviewDrafts",
      where: "spot = ?",
      whereArgs: [spot]
    );

    print('RES: $res');
    if (res.length == 1) {
      return res.map((c) => ReviewDraftDTO.fromJson(c).toModel()).toList();
    }

    return [];
  }

  Future<String?> findId(String spot) async {
    try {
      QuerySnapshot docs = await _fireCloud.get();
      List<DocumentSnapshot> foundDocs = [];
      String? id ;
      for (var doc in docs.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print(data);
        if (data['spot'] == spot) {
            id = doc.id;
            break;
        }
      }

      return id;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: "Failed to get review: '${e.code}': ${e.message}",
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future updateUnifinishedDraftCount(String spot, bool add) async {
    try {
      String? id = await findId(spot);
      DocumentSnapshot<Map<String, dynamic>> reviewRef = await _fireCloud.doc(id).get();
      if (add) {
        await reviewRef.reference.update({
          'count': FieldValue.increment(1)
        });
      } else {
        await reviewRef.reference.update({
          'count': FieldValue.increment(-1)
        });
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: "Failed to get review: '${e.code}': ${e.message}"
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> insertDraft(ReviewDraft draft) async {
    print('INSERTING DRAFT: ${draft.image}');
    
    if (draft.image != null) {
      draft.image = await FileManagerDAO().saveImage(draft.image!, draft.spot!);
    }
    print("New draft image path: ${draft.image}");
    final db = await dbProvider.getDatabase();
    print('SAVING: ${ReviewDraftDTO.fromModel(draft).toJson()}');
    await updateUnifinishedDraftCount(draft.spot!, true);
    await db.insert('ReviewDrafts', ReviewDraftDTO.fromModel(draft).toJson());
  }

  Future<void> updateDraft(ReviewDraft draft, String spot) async {
    final db = await dbProvider.getDatabase();
    await db.update(
      'ReviewDrafts',
      ReviewDraftDTO.fromModel(draft).toJson(),
      where: 'spot = ?',
      whereArgs: [spot]
    );
  }

  Future<void> deleteDraft(String spot) async {
    final db = await dbProvider.getDatabase();
    await db.delete(
      'ReviewDrafts',
      where: 'spot = ?',
      whereArgs: [spot]
    );
    // await updateUnifinishedDraftCount(spot, false);
  }

  Future<void> deleteAllDrafts() async {
    final db = await dbProvider.getDatabase();
    await db.delete('ReviewDrafts');
  }

  Future<void> insertDraftsToUpload(ReviewDraft draft) async {
    final db = await dbProvider.getDatabase();
    print('SAVING: ${ReviewDraftDTO.fromModel(draft).toJson()}');
    await db.insert('ToUpload', ReviewDraftDTO.fromModel(draft).toJson());
  }

  Future<void> deleteDraftsToUpload() async {
    final db = await dbProvider.getDatabase();
    await db.delete('ToUpload');
  }

  Future<List<ReviewDraft>> getAllDraftsToUpload() async {
    final db = await dbProvider.getDatabase();
    var res = await db.query("ToUpload");

    return res.isNotEmpty
        ? res.map((c) => ReviewDraftDTO.fromJson(c).toModel()).toList()
        : [];
  }

  Future<void> killDatabase() async {
    await dbProvider.killDatabase();
  }
}