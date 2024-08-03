import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function (File image) onPickImage;

  @override
  State <ImageInput> createState() => _ImageInput();
}

  class _ImageInput extends State<ImageInput> {
   File? _selectedImage;


   void _choosePicture() async{
     final  imagePicker = ImagePicker();
     final pickedImage = await imagePicker.pickImage(
       source: ImageSource.gallery, maxWidth: 600,);

     if(pickedImage == null){
       return;
     }
     setState(() {
       _selectedImage = File(pickedImage.path);
     });

     widget.onPickImage(_selectedImage!);
   }

   void _takePicture() async {
    final  imagePicker = ImagePicker();
   final pickedImage =
       await imagePicker.pickImage(
         source: ImageSource.camera, maxWidth: 600,);

   if(pickedImage == null){
     return;
   }
   setState(() {
     _selectedImage = File(pickedImage.path);
   });
    widget.onPickImage(_selectedImage!);
   }

   void _showOptions(BuildContext context){
     showModalBottomSheet(
         context: context,
         builder: (ctx) => Container(
           height: 150,
           child: Column(
             children: [
               ListTile(
                 leading: const Icon(Icons.camera_alt_outlined),
                 title: const Text('Take Picture'),
                 onTap: () {
                   Navigator.of(context).pop();
                   _takePicture();
                 },
               ),
               ListTile(
                 leading: const Icon(Icons.photo),
                 title:  const Text('Choose From Gallery'),
                 onTap: () {
                   Navigator.of(context).pop();
                   _choosePicture();
                 },
               ),
             ],
           ),
         ),
     );
   }

  @override
    Widget build(BuildContext context) {
     return Column(
       children: [
         if(_selectedImage != null)
        GestureDetector(
         onTap: () => _showOptions(context),
           child: Image.file(_selectedImage! ,
             fit: BoxFit.cover,
             width: double.infinity,
           height: 250,
           ),
        ),

      if(_selectedImage == null)
        Container(
          height : 250 ,
        width : double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2)
          )
        ),
          alignment: Alignment.center,
          child: ElevatedButton.icon(
         onPressed: () => _showOptions(context),
         icon: const Icon(Icons.upload_file),
        label: const Text('Upload Image'),

        ),
        ),
        ]

      );
    }
  }


