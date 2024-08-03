import 'package:uuid/uuid.dart';
import 'dart:io';
const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,


  });

  final double latitude;
  final double longitude;
}


class Place{
   Place({
     required this.title,
     required this.image,
     required this.location,
      String? id,

   })
       : id = id ?? uuid.v4();

  final String id;
  final File image;
  final String title;
  final PlaceLocation location;

}