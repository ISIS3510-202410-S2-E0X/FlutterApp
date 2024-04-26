import 'package:foodbook_app/data/dtos/reviewdraft_dto.dart';
import 'package:foodbook_app/data/models/reviewdraft.dart';
import 'package:foodbook_app/data/data_sources/database_provider.dart';

class ReviewDraftRepository {
  final DatabaseProvider dbProvider;

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

  Future<void> insertDraft(ReviewDraft draft) async {
    final db = await dbProvider.getDatabase();
    print('SAVING: ${ReviewDraftDTO.fromModel(draft).toJson()}');
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

  Future<void> deleteDraft(int id) async {
    final db = await dbProvider.getDatabase();
    await db.delete(
      'ReviewDrafts',
      where: 'id = ?',
      whereArgs: [id]
    );
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