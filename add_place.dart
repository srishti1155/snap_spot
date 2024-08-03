import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:snap_spot/model/places.dart';
import 'package:snap_spot/provider/user_places.dart';
import 'package:snap_spot/widgets/image_input.dart';
import 'package:snap_spot/widgets/location_input.dart';
import 'dart:io';

import 'package:snap_spot/widgets/places_list.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen ({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceState();
}

class _NewPlaceState extends ConsumerState<NewPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  LocationData? _selectedLocation;


 void _selectLocation(LocationData location){
   _selectedLocation =  location;
 }

  void _savePlace() {
    final enteredTitle = _titleController.text;

    if(enteredTitle.isEmpty || _selectedImage == null || _selectedLocation == null) {
      return;
    }

    final location = PlaceLocation(
        latitude: _selectedLocation!.latitude!,
        longitude: _selectedLocation!.longitude!);

    ref.read(userPlacesProvider.notifier).addPlace(
        enteredTitle,  _selectedImage! , location ,
    );

    Navigator.of(context).pop();

  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(decoration:
              const InputDecoration(label: Text('Title'),),
                controller: _titleController,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 14,),

              ImageInput(
                  onPickImage: (image) {
                _selectedImage = image;
              }),

              const SizedBox(height: 16,),

              LocationInput(onSelectLocation :  _selectLocation),

              const SizedBox(height: 16,),
              ElevatedButton.icon(
                  onPressed: _savePlace,
                  label: const Text('Add Place'),
                 //icon: const Icon(Icons.add),
            )
            ],
          ),
        ),
    );
  }
}
