import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_cartoongan_with_server/services/file_picker_service.dart';
import 'package:flutter_image_cartoongan_with_server/services/ml_service.dart';

class CartoonPage extends StatefulWidget {
  @override
  _CartoonPageState createState() => _CartoonPageState();
}

class _CartoonPageState extends State<CartoonPage> {
  final MLService _mlService = MLService();
  final FilePickerService _filePickerService = FilePickerService();

  Uint8List? defaultImage;
  Uint8List? cartoonImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CartoonGAN'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: selectImage,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(

          children: [
            if(defaultImage !=null)
            LoadingImage(defaultImage!),
            const Center(
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 50,
              ),
            ),
            if(cartoonImage !=null)
            LoadingImage(cartoonImage!),
          ],
        ),
      ),
    );
  }

  Widget LoadingImage(Uint8List imageData) {
    if (imageData == null) {
      return const Center(
        child: Text(
          'No Image',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    } else if (imageData.length == 0) {
      return Center(
        child: Column(
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              height: 5,
            ),
            Text('Loading'),
          ],
        ),
      );
    } else {
      return Image.memory(
        imageData,
        fit: BoxFit.fitWidth,
      );
    }
  }

  void selectImage() async {
    setState(() {
      defaultImage = Uint8List(0);
      cartoonImage = Uint8List(0);
    });

    var imageData = await _filePickerService.imageFilePickAsBytes();

    if (imageData != null) {
      setState(() {
        defaultImage = imageData;
      });

      var cartoonImageData = await _mlService.convertCartoonImage(imageData);

      setState(() {
        if (cartoonImageData == null) {
          cartoonImage = null;
        } else {
          cartoonImage = cartoonImageData;
        }
      });
    } else {
      setState(() {
        defaultImage = null;
        cartoonImage = null;
      });
    }
  }
}
