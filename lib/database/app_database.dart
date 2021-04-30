import 'package:flutter/cupertino.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  // static is not immutable, final is
  static final String _tableName = 'photo_sound';
  Future<dynamic> upgrade({@required String fieldInfo}) async {
    return createDatabase().then((db) {
      return db.rawQuery('ALTER TABLE $_tableName ADD $fieldInfo');
    });
  }

  Future<Database> createDatabase() async {
    String path = join(await getDatabasesPath(), 'phoso.db');

    return openDatabase(
      path,
      onDowngrade: onDatabaseDowngradeDelete,
      onCreate: (db, version) {
        db
            .execute('CREATE TABLE IF NOT EXISTS $_tableName ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT , '
                'playlistName TEXT,'
                'photoSrc TEXT, '
                'soundSrc TEXT, '
                'soundName TEXT,'
                // 0 = false;
                // 1 = true;
                'favorite INT DEFAULT 0)')
            .onError(
              (error, stackTrace) => print(error),
            );
      },
      version: 3,
    );
  }

  Future<int> save(PhotoSound photoSound) {
    return createDatabase().then((db) {
      final Map<String, dynamic> phosoMap = Map();
      phosoMap['playlistName'] = photoSound.playlistName;
      phosoMap['photoSrc'] = photoSound.photoSrc;
      phosoMap['soundSrc'] = photoSound.soundSrc;
      phosoMap['soundName'] = photoSound.soundName;
      phosoMap['favorite'] = (photoSound.favorite) ? 1 : 0;
      return db.insert(_tableName, phosoMap);
    });
  }

  Future<List<PhotoSound>> findAll({String orderBy = 'id DESC'}) {
    return createDatabase().then((db) {
      return db
          .rawQuery(
        'SELECT * FROM $_tableName ORDER BY $orderBy',
      )
          .then((maps) {
        final List<PhotoSound> photoSound = [];
        for (Map<String, dynamic> map in maps) {
          final PhotoSound phoso = PhotoSound(
            id: map['id'],
            playlistName: map['playlistName'],
            photoSrc: map['photoSrc'],
            soundSrc: map['soundSrc'],
            soundName: map['soundName'],
            favorite: (map['favorite'] == 1),
          );
          if (!PhotoSound.phoso.contains(phoso)) {
            PhotoSound.phoso.add(phoso);
          }
          photoSound.add(phoso);
        }

        return photoSound;
      });
    });
  }

  Future<void> del() async {
    await deleteDatabase(await getDatabasesPath() + 'phoso.db');
  }

  Future<PhotoSound> getWhereId(int id) {
    return createDatabase().then((db) {
      return db.query(_tableName, where: "id = ?", whereArgs: [id]).then((maps) {
        PhotoSound photoSound;

        maps.forEach((element) {
          photoSound = PhotoSound(
            id: element['id'],
            playlistName: element['playlistName'],
            photoSrc: element['photoSrc'],
            soundSrc: element['soundSrc'],
            soundName: element['soundName'],
            favorite: (element['favorite'] == 1),
          );
        });

        return photoSound;
      });
    });
  }

  Future<List<PhotoSound>> getWherePlaylistNameLike(String playlistName) {
    return createDatabase().then((db) {
      return db.query(
        _tableName,
        where: 'playlistName LIKE ?',
        whereArgs: ['$playlistName%'],
      ).then((maps) {
        final List<PhotoSound> photoSound = [];
        for (Map<String, dynamic> map in maps) {
          final PhotoSound phoso = PhotoSound(
            id: map['id'],
            playlistName: map['playlistName'],
            photoSrc: map['photoSrc'],
            soundSrc: map['soundSrc'],
            soundName: map['soundName'],
            favorite: (map['favorite'] == 1),
          );
          PhotoSound.phoso.add(phoso);
          photoSound.add(phoso);
        }
        return photoSound;
      });
    });
  }

  Future<List<PhotoSound>> getWherePlaylistName(String playlistName) {
    return createDatabase().then((db) {
      return db.query(
        _tableName,
        where: 'playlistName = ?',
        whereArgs: [playlistName],
      ).then((maps) {
        final List<PhotoSound> photoSound = [];
        maps.forEach((element) {
          final PhotoSound phoso = PhotoSound(
            id: element['id'],
            playlistName: element['playlistName'],
            photoSrc: element['photoSrc'],
            soundSrc: element['soundSrc'],
            soundName: element['soundName'],
            favorite: (element['favorite'] == 1),
          );
          PhotoSound.phoso.add(phoso);
          photoSound.add(phoso);
        });
        return photoSound;
      });
    });
  }

  Future<void> edit(PhotoSound photoSound) async {
    return createDatabase().then(
      (db) {
        return db.update(
          _tableName,
          {
            'playlistName': photoSound.playlistName,
            'photoSrc': photoSound.photoSrc,
            'soundSrc': photoSound.soundSrc,
            'soundName': (photoSound.soundName == null) ? '' : photoSound.soundName,
            'favorite': (photoSound.favorite) ? 1 : 0,
          },
          where: 'id = ?',
          whereArgs: [photoSound.id],
        );
      },
    );
  }

  Future<String> drop() async {
    return createDatabase().then((db) {
      return db.delete(_tableName).then((value) {
        return value.toString();
      });
    });
  }

  Future<int> delete({
    @required String where,
    @required List<Object> whereArgs,
  }) async {
    return createDatabase().then((db) {
      return db.delete(
        _tableName,
        where: where,
        whereArgs: whereArgs,
      );
    });
  }
}
