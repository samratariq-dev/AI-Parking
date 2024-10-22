import 'dart:html';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarOut extends StatefulWidget {
  @override
  _CarOutState createState() => _CarOutState();
}

class _CarOutState extends State<CarOut> {
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

    final uri = Uri.parse('http://127.0.0.1:5000/CarOut');
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
        title: Text('Check Out'),
      ),
      body: Column(
        children: [
          Center(
            child:
                _image == null ? const Text('No image selected.') : Image.memory(_image!),
                
          ),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const AppliedForOut()));

          }, child: const Text('Applied For Out'))
          
        ],
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
                      content: Text('car removed from DB'),
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


class AppliedForOut extends StatefulWidget {
  const AppliedForOut({super.key});

  @override
  State<AppliedForOut> createState() => _AppliedForOutState();
}

class _AppliedForOutState extends State<AppliedForOut> {
   String plateText = "";
  final _form_key = GlobalKey<FormState>();
  final _textController = TextEditingController();
  String searchedText = "";

  void searchApi() {
    final url = Uri.parse('http://127.0.0.1:5000/searchDelete?query=$plateText');

    http.get(url).then((response) {
      if (response.statusCode == 200) {
        final result = response.body;
        setState(() {
          searchedText = result;
        });
      } else {
        setState(() {
          searchedText = 'Request failed with status: ${response.statusCode}.';
        });
      }
    }).catchError((error) {
      setState(() {
        searchedText = 'Request failed with error: $error.';
      });
     
    });
  }

  OutlineInputBorder _inputFormDeco() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(
            width: 1.0, color: Colors.black, style: BorderStyle.solid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350,
              child: Form(
                key: _form_key,
                child: TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Plate Number:',
                    enabledBorder: _inputFormDeco(),
                    focusedBorder: _inputFormDeco(),
                  ),
                  onSaved: (newValue) {},
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  plateText = _textController.text;
                  print(plateText);
                  if (plateText != "")
                    searchApi();
                  else
                    print('no value');
                },
                child: Text('Search')),
                SizedBox(height: 20,),

                Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  ),
  padding: EdgeInsets.all(16),
  child: Text(
    searchedText,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    ),
  ),
),

            
          ],
        ),
      ),
    );
  }
}