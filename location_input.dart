
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget{
  final Function(LocationData) onSelectLocation;

  const LocationInput({required this.onSelectLocation , super.key});

  @override
  State<LocationInput> createState() => _LocationInput();

}

class _LocationInput extends State<LocationInput> {
  LocationData? _selectedLocation ;
 var isGettingLocation = false;

  void _getCurrentLocation () async {
    Location location =  Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData ;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      isGettingLocation = false;
      _selectedLocation  =  locationData ;
    });

    widget.onSelectLocation(locationData);
  }

    @override
  Widget build(BuildContext context) {

    Widget previewContent = Text('No location', textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );


    if(isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    
    if(isGettingLocation == false && _selectedLocation != null) {
      previewContent  = Text(
          'Latitude: ${_selectedLocation!.latitude}, Longitude: ${_selectedLocation!.longitude}',
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
      )
      );
    }


   return Column(
     children: [
       Container(
         alignment: Alignment.center,
         width: double.infinity,
         height: 170,
         decoration: BoxDecoration(
           border: Border.all(
             width: 1,
             color:  Theme.of(context).colorScheme.primary.withOpacity(0.2),
           )
         ),
         child: previewContent
       ),
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           TextButton.icon(
               icon: const Icon(Icons.location_on),
           label: const Text('Get current Location'),
             onPressed: _getCurrentLocation,
           ),

           TextButton.icon(
               icon: const Icon(Icons.map),
               onPressed: () {} ,
               label: const Text('Select on Map')
           )
         ],
       )
     ],
   );
  }
}
