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
  GoogleMapController? _mapController;
  LocationData? _locationData;
  LatLng _currentLocation = const LatLng(0, 0);
  final double _zoom = 16.0;
  final Set<Circle> _circles = {}; // Set to store circles on the map

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _currentLocation = const LatLng(0, 0);
        });
        return;
      }
    }

    // Check location permission
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        setState(() {
          _currentLocation = const LatLng(0, 0);
        });
        return;
      }
    }

    try {
      _locationData = await location.getLocation();
      setState(() {
        _currentLocation =
            LatLng(_locationData!.latitude!, _locationData!.longitude!);
      });

      // Move the map camera to current location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentLocation),
        );
        _saveMapData();
      }
    } catch (e) {
      print('Error getting current location: $e');
      setState(() {
        _currentLocation = const LatLng(0, 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient'),
        centerTitle: true,
      ),
      body: GoogleMap(
        //ขออนุญาตให้เข้าดู location ของเราได้ - เจ้าของบ้านจะอนุญาตให้เข้าถึงตำแหน่งหรือเปล่า?
        myLocationEnabled: true,
        // กำหนดให้ แผนที่แสดงออกมาในรูปแบบ normal
        mapType: MapType.normal,
        // คำสั่งให้สร้างแผนที่ขึ้นมา
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        // กำหนดตำแหน่งเริ่มต้นให้กับแอปพลิเคชัน โดยตำแหน่งเริ่มต้นอยู่ที่อนุสาวรีย์ มีการซูมอยู่ที่ 16
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: _zoom,
        ),
        markers: {
          Marker(
              markerId: const MarkerId('currentLocation'),
              position: _currentLocation),
        },
        circles: _circles,
      ),
    );
  }

  //ฟังก์ชัน _saveMapData() มีหน้าที่ เก็บตำแหน่ง ณ ปัจจุบัน ไปไว้ที่ Firebase
  void _saveMapData() async {
    var mapData = {
      "latitude": _currentLocation.latitude,
      "longitude": _currentLocation.longitude,
    };

    setState(() {
      _circles.add(Circle(
        circleId: const CircleId('patient'),
        center: LatLng(_currentLocation.latitude, _currentLocation.longitude),
        radius: 100,
        strokeColor: Colors.blue,
        strokeWidth: 2,
        fillColor: Colors.blue.withOpacity(0.2),
      ));
    });

    // Timer เป็นการกำหนดเวลาให้ส่งค่า latitude และ longitude ทุก ๆ _ วินาที
    Timer.periodic(const Duration(seconds: 3), (timer) {
      // print(_currentLocation);
      FirebaseFirestore.instance
          .collection("patient")
          .doc("LatLng")
          // .doc()
          .set(mapData)
          .catchError((error) {
        print("Error saving map data: $error");
      });
    });
  }
}
