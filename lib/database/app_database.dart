import 'package:phoso/models/photo_sound.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Future<Database> createDatabase() async {
    final String path = join(await getDatabasesPath(), 'phoso.db');

    return openDatabase(
      path,
      onDowngrade: onDatabaseDowngradeDelete,
      onCreate: (db, version) {
        db.execute('CREATE TABLE photo_sound('
            'id INTEGER PRIMARY KEY AUTOINCREMENT , '
            'playlistName TEXT, '
            'photoSrc TEXT, '
            'soundSrc TEXT, '
            'soundName TEXT)');
      },
      version: 1,
    );
  }

  static Future<int> save(PhotoSound photoSound) {
    return createDatabase().then((db) {
      final Map<String, dynamic> contactMap = Map();
      contactMap['playlistName'] = photoSound.playlistName;
      contactMap['photoSrc'] = photoSound.photoSrc;
      contactMap['soundSrc'] = photoSound.soundSrc;
      contactMap['soundName'] = photoSound.soundName;
      return db.insert('photo_sound', contactMap);
    });
  }

  static Future<List<PhotoSound>> findAll() {
    return createDatabase().then((db) {
      return db.query('photo_sound').then((maps) {
        final List<PhotoSound> photoSound = [];
        for (Map<String, dynamic> map in maps) {
          final PhotoSound phoso = PhotoSound(
            id: map['id'],
            playlistName: map['playlistName'],
            photoSrc: map['photoSrc'],
            soundSrc: map['soundSrc'],
            soundName: map['soundName'],
          );
          PhotoSound.phoso.add(phoso);
          photoSound.add(phoso);
        }
        return photoSound;
      });
    });
  }

  static Future<void> deleteDatabase() async {
    return createDatabase().then((db) => deleteDatabase());
  }

  static Future<PhotoSound> getWhere(int id) {
    return createDatabase().then((db) {
      return db.rawQuery("SELECT * FROM photo_sound WHERE id = ?", [id]).then(
          (maps) {
        PhotoSound photoSound;

        maps.forEach((element) {
          photoSound = PhotoSound(
              id: element['id'],
              playlistName: element['playlistName'],
              photoSrc: element['photoSrc'],
              soundSrc: element['soundSrc'],
              soundName: element['soundName']);
        });

        return photoSound;
      });
    });
  }

  static Future<void> edit(PhotoSound photoSound) async {
    // O = OK
    // 1 = ERROR
    return createDatabase()
        .then(
          (db) {
            return db.rawQuery(
              "UPDATE photo_sound SET playlistName = ?, photoSrc = ?, soundSrc = ?, soundName = ? WHERE id = ?",
              [
                photoSound.playlistName,
                photoSound.photoSrc,
                photoSound.soundSrc,
                (photoSound.soundName == null) ? '' : photoSound.soundName,
                photoSound.id
              ],
            );
          },
        );
  }

  static Future<String> drop() async {
    return createDatabase().then((db) {
      return db.delete('photo_sound').then((value) {
        return value.toString();
      });
    });
  }

  static Future<int> delete({
    String where,
    List<dynamic> whereArgs,
  }) async {
    return Future.delayed(Duration(seconds: 5), () {
      return createDatabase().then((db) {
        return db.delete(
          'photo_sound',
          where: where,
          whereArgs: whereArgs,
        );
      });
    });
  }
}
