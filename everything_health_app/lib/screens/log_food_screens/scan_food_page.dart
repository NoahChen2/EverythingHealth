import '../log_food_page.dart';
import 'package:flutter/material.dart';
import '../../widgets/camera_widget.dart';

class ScanFoodPage extends StatefulWidget {
  final Function addFoodFunc;

  const ScanFoodPage({super.key, required this.addFoodFunc});
  
  @override
  State<ScanFoodPage> createState() => _ScanFoodPageState();
}

class _ScanFoodPageState extends State<ScanFoodPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return CameraApp();
    return Container(
      margin: EdgeInsets.only(top: 60),
      width: double.infinity,
      color: const Color.fromARGB(255, 0, 36, 72),
      child: Column(
        children: [
          GestureDetector(
          onTap: () => print("Scan Barcode"),
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            height: 100,
            width: 500,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 65, 224, 192)),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text("Scan Barcode", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), overflow: TextOverflow.clip)),
                  SizedBox(width: 20),
                  Icon(Icons.barcode_reader, color: Colors.white),
                ])
          ),
        ),
        GestureDetector(
          onTap: () => print("Analyze Picture"),
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            height: 100,
            width: 500,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 65, 224, 192)),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text("Analyze Picture", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), overflow: TextOverflow.clip)),
                  SizedBox(width: 20),
                  Icon(Icons.camera_alt, color: Colors.white),
                ])
          ),
        ),
        ]
      )
    );
  }
}