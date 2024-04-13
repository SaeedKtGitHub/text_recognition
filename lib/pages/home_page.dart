import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? selectedMedia;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUi(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Text Recognition'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: ()async{
            List<MediaFile>? media =await GalleryPicker.pickMedia(
                context: context,singleMedia: true);
            if(media!=null && media.isNotEmpty){
              var data=await media.first.getFile();
              setState(() {
                selectedMedia=data;
              });
              print("Gotttttttt the image");
            }
          }),
    );
  }
  Widget _buildUi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: [
        _imageView(),
         _extractTextView(),
      ],
    );

  }
  Widget _imageView() {
    if(selectedMedia==null ){
      print("hiiiiiiiiiii");
      return const Center(
        child: Text('Pick an image for text recognition'),
      );
    }
    return Center(
      child: Image.file(selectedMedia!,
      width: 200,
      ),
    );
  }

  Widget _extractTextView() {
    if(selectedMedia==null ){
      return Text('No Result');
    }
    return FutureBuilder(future: _extractText(selectedMedia!),
        builder: (context,snapshot){
          return Text(snapshot.data ?? "",style: TextStyle(
            fontSize: 24
          ),);
        });
  }
  Future<String?> _extractText(File file)async{
    final textRecognizer=TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage=InputImage.fromFile(file);
    final RecognizedText recognizedText=await textRecognizer.processImage(inputImage);
    String text=recognizedText.text;
    textRecognizer.close();
    return text;
  }

}



