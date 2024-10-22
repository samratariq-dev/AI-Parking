import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  String plateText = "";
  final _form_key = GlobalKey<FormState>();
  final _textController = TextEditingController();
  String searchedText = "";

  void searchApi() {
    final url = Uri.parse('http://127.0.0.1:5000/search?query=$plateText');

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
