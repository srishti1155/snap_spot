import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:snap_spot/model/places.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db , version){
      return db.execute('CREATE TABLE user_places('
          'id TEXT PRIMARY KEY , title TEXT, image TEXT , lat REAL , lng REAL )');
    },
    version: 1,
  );
  return db;
}


class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data =  await db.query('user_places');
    final places = data.map((row) =>
        Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: row['image']  as File,
            location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                )
        ),
    ).toList();

    state = places;
  }

  void  addPlace(String title,  File image, PlaceLocation location) async{
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
  final copiedImage = await image.copy('${appDir.path}/$filename}');
    
    final newPlace = Place(title: title, image: copiedImage, location : location);
    
      final db = await _getDatabase();
       db.insert('user_places', {
         'id' : newPlace.id,
         'title' : newPlace.title,
         'image' : newPlace.image.path,
         'lat' : newPlace.location.latitude,
         'lng' : newPlace.location.longitude,

       });
   
    state = [newPlace, ...state];
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlaceNotifier, List<Place>>(
    (ref) => UserPlaceNotifier(),
);

