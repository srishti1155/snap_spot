import 'package:flutter/material.dart';
import 'package:snap_spot/model/places.dart';
import 'package:snap_spot/screens/place_detail.dart';

class PlacesList extends StatelessWidget {
  const PlacesList ({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if(places.isEmpty) {
      return  Center(
        child:  Text('No places added yet' ,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        ),
      );
    }
    return ListView.builder(
        itemCount : places.length,
        itemBuilder: (ctx,index) => ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: FileImage(places[index].image)
          ),
          title:  Text(places[index].title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              )
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => PlaceDetail(place: places[index])
            )
            );
          } ,
        ),
    );
  }

}