import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking/CarInn.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'CarOut.dart';
import 'Search.dart';
List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Parking',
      home:MainHomeScr(),
      
    );
  }
}



class MainHomeScr extends StatefulWidget {
  const MainHomeScr({super.key});

  @override
  State<MainHomeScr> createState() => _MainHomeScrState();
}

class _MainHomeScrState extends State<MainHomeScr> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title:const Center(child: Text('Parking Management Software'))),
         body: SingleChildScrollView(
           child: Column(
            children: [
              const SizedBox(height: 10,),
              
                
              ////////////////////////////
               SizedBox(
               height: 190,
               child: Card(
              shape: RoundedRectangleBorder(      
                side: const BorderSide(
                    color: Colors.black,
                  ), 
               borderRadius: BorderRadius.circular(20.0),
               ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              // ignore: sized_box_for_whitespace
              child: Container(
                height: 200,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/CarCheckIn.png'),
                        fit: BoxFit.fill,
                      )),
                    ),
                    Container(
                      color: Colors.white,
                      child: Center(
                        // ignore: sized_box_for_whitespace
                        child: Container(
                            height: 200,
                            child: Column(
                              children: [
                                const Text(
                                  'Cars In',
                                  style: TextStyle(fontFamily: 'Anton'),
                                ),
                                Row(
                                  children: const [
                                    Icon(Icons.group_work_outlined,
                                        color: Colors.green),
                                    Flexible(
                                        child: Text(
                                            'Click here to enter you car and detect space',
                                            style: TextStyle(
                                                color: Colors.grey, fontSize: 10)))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: const [
                                    Icon(Icons.access_time_filled, color: Colors.green),
                                    Flexible(
                                        child: Text(
                                            'Access up-to-date Parking reports and  updates',
                                            style: TextStyle(
                                                color: Colors.grey, fontSize: 10)))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Colors
                                                  .green), // Set the border radius to 20 pixels
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                             Navigator.push(context, MaterialPageRoute(builder: (context) => ImageUpload()));
                                    },
                                    child: const Text(
                                      'Car CheckIn',
                                      style:
                                          TextStyle(color: Colors.green, fontSize: 10),
                                    ))
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
               ),
             ),
              ///
              const SizedBox(height: 20,),
              
              ///////////////////////
              SizedBox(
               height: 180,
               child: Card(
                 shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.black,
                  ), 
            borderRadius: BorderRadius.circular(20.0),
                 ),
                 child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
            child: SizedBox(
              height: 200,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: [
                  Container(
                    color: Colors.white,
                    child: Center(
                      // ignore: sized_box_for_whitespace
                      child: Container(
                          height: 200,
                          child: Column(
                            children: [
                              const Text(
                                'Search Cars',
                                style: TextStyle(fontFamily: 'Anton'),
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.menu, color: Colors.green),
                                  Flexible(
                                      child: Text(
                                          'Search Your Parked Cars At your finger tips ',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 10)))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.location_disabled_rounded, color: Colors.green),
                                  Flexible(
                                      child: Text(
                                          'Just Type the Registration Number and find your cars with location',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 10)))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        side: const BorderSide(
                                            color: Colors
                                                .green), // Set the border radius to 20 pixels
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Main(),
                                        ));
                                  },
                                  child: const Text(
                                    'Search Cars',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 10),
                                  ))
                            ],
                          )),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/SearchCar.jpg'),
                      fit: BoxFit.fill,
                    )),
                  ),
                ],
              ),
            ),
                 ),
               ),
             ),
              ///
              ///
              const SizedBox(height: 20,),

              SizedBox(
      height: 190,
      child: Card(
         shape: RoundedRectangleBorder(   
       side: const BorderSide(
                    color: Colors.black,
          ),     
        borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0,top: 8.0),
          // ignore: sized_box_for_whitespace
          child: Container(
            height: 200,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: [
                Container(color: Colors.white,
                child: 
            Center(
              child: SizedBox(
                height: 200,
                child: 
                Column(
                  children: [
                    const Text('Car Check Out',style: TextStyle(fontFamily: 'Anton'),),
                    Row(children: const [
                      Icon(Icons.fact_check_outlined, color: Colors.green),
                      Flexible(child: Text('Check Out Of parking Lot',style: TextStyle(color: Colors.grey,fontSize: 10)))
                    ],),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0),
                          side: const BorderSide(color: Colors.green),                         // Set the border radius to 20 pixels
                        ),
                      ),
                    ),
                      onPressed: () {    
                            Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>CarOut()
                                      ),
                                    );
                    }, child: const Text('Cars CheckOut',style: TextStyle(color: Colors.green,fontSize: 10),))
            
                  ],
                )
              ),
            ),
      
                ),
                            Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/CarOut.jpg'),
                      fit: BoxFit.fill,
                      )
                  ),
                ),
              ],
              ),
          ),
        ),
      ),
    ),

           const SizedBox(height: 20,)     ,
                
                
            ],
               ),
         ),
       );
  }
}



class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen(this.cameras);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          try {
          
            await _initializeControllerFuture;
            XFile image = await _controller.takePicture();
           
            await sendImage(image.path);
       
            Navigator.pop(context, image.path);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }

  Future<void> sendImage(String imagePath) async {
    print('APi started');
    const url = 'http://127.0.0.1:5000/upload-image';
    final imageBytes = File(imagePath).readAsBytesSync();
    final response = await http.post(Uri.parse(url), body: imageBytes);
    print(response.body);
  }
}
