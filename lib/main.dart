import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'firebase_options.dart';

// เชื่อม Google Maps เรียบร้อย
// เชื่อม Firecase ชื่อ test amatrix เรียบร้อย
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Patient'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyMapPageState();
}

class MyMapPageState extends State<MyHomePage> {
  final Completer<GoogleMapController> _controllerss = Completer();

  late LocationData currentLocation;

  final LatLng _center = const LatLng(13.928912169164503, 100.57660708828934);

  final LatLng _censadsadsater =
      const LatLng(13.928912169164503, 100.57660708828934);
  final double _zoom = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        //ขออนุญาตให้เข้าดู location ของเราได้ - เจ้าของบ้านจะอนุญาตให้เข้าถึงตำแหน่งหรือเปล่า?
        myLocationEnabled: true,
        // กำหนดให้ แผนที่แสดงออกมาในรูปแบบ normal
        mapType: MapType.normal,
        // คำสั่งให้สร้างแผนที่ขึ้นมา
        onMapCreated: (GoogleMapController controller) {
          _controllerss.complete(controller);
        },
        // กำหนดตำแหน่งเริ่มต้นให้กับแอปพลิเคชัน โดยตำแหน่งเริ่มต้นอยู่ที่อนุสาวรีย์ มีการซูมอยู่ที่ 16
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: _zoom,
        ),
      ),

      // สร้างปุ่มขึ้นมา โดยมีชื่อว่า My location
      floatingActionButton: FloatingActionButton.extended(
        // เมื่อกดปุ่ม จะรับค่าตำแหน่งของอุปกรณ์ ส่งผ่านเข้าไปในตัวแปร currentLocation และไปยังฟังก์ชัน _goToMyLocation() และ _saveMapData();
        onPressed: () async {
          currentLocation = await Location().getLocation();

          _goToMyLocation();
          _saveMapData();
        },
        label: const Text('My location'),
        icon: const Icon(Icons.near_me),
      ),
    );
  }

  //ฟังก์ชัน _goToMyLocation() มีหน้าที่ หาตำแหน่งใหม่จากได้ที่กำหนดเริ่มต้น เป็นตำแหน่ง ณ ปัจจุบัน
  Future _goToMyLocation() async {
    final controller = await _controllerss.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          zoom: 16,
        ),
      ),
    );
  }

  //ฟังก์ชัน _saveMapData() มีหน้าที่ เก็บตำแหน่ง ณ ปัจจุบัน ไปไว้ที่ Firebase
  void _saveMapData() async {
    var mapData = {
      "latitude": currentLocation.latitude,
      "longitude": currentLocation.longitude,
    };

    // Timer เป็นการกำหนดเวลาให้ส่งค่า latitude และ longitude ทุก ๆ _ วินาที
    Timer.periodic(const Duration(seconds: 3), (timer) {
      print(currentLocation);
      FirebaseFirestore.instance
          .collection("maps1")
          .doc("LatLng")
          // .doc()
          .set(mapData)
          .catchError((error) {
        print("Error saving map data: $error");
      });
    });
  }
}
