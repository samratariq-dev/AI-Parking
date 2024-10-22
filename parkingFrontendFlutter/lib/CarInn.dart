import 'dart:html';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  Uint8List? _image;
  String _statusMessage = '';

  Future<void> _getImage() async {
    final input = FileUploadInputElement()..accept = 'image/*';
    input.click();

    await input.onChange.first;
    final file = input.files!.first;
    final reader = FileReader();

    reader.onLoadEnd.listen((e) {
      setState(() {
        final bytes = reader.result as Uint8List?;
        _image = bytes;
      });
    });

    reader.readAsArrayBuffer(file);
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }

    final uri = Uri.parse('http://127.0.0.1:5000/upload');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromBytes('image', _image!,
        filename: 'image.png'));
    final response = await request.send();
    print(response);

    setState(() {
      _statusMessage =
          response.statusCode == 200 ? 'Image uploaded' : 'Upload failed';
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car In Welcome'),
      ),
      body: Center(
        child:
            _image == null ? Text('No image selected.') : Image.memory(_image!),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _getImage,
            tooltip: 'Select Image',
            child: Icon(Icons.add_a_photo),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed:() {
              _uploadImage();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Car has been Parked successfully!'),
                  duration: Duration(seconds: 3),
                ),
              );
            }, 
            tooltip: 'Upload Image',
            child: Icon(Icons.cloud_upload),
          ),

        ],
      ),
    );
  }
}
