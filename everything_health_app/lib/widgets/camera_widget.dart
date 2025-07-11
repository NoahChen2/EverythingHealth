// lib/camera_widget.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../main.dart';

// You might want to make this function private if it's only used internally by this widget
// or keep it public if other parts of your app might need to query cameras directly.

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController? _controller; // Make nullable to handle initial uninitialized state
  Future<void>? _initializeControllerFuture; // Make nullable

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      if (cameras.isEmpty) {
        // Handle case where no cameras are found
        print('No cameras found on this device.');
        setState(() {
          // You might want to show an error message instead of loading indicator
        });
        return;
      }
      final obsCamera = cameras.firstWhere(
        (camera) => camera.name.contains('OBS'),
        // If not found, fall back to the first available camera
        orElse: () => cameras.first,
      );
      // Initialize the controller with the first available camera
      _controller = CameraController(
        obsCamera, // Use the first available camera
        ResolutionPreset.medium,
        enableAudio: true, // Typically needed for video recording, good practice
      );

      _initializeControllerFuture = _controller!.initialize(); // Initialize the controller

      // Ensure the UI updates when initialization is complete
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
      // Handle error (e.g., show an error message to the user)
      setState(() {
        _controller = null; // Mark controller as not initialized on error
        _initializeControllerFuture = null;
      });
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose(); // Use null-safe call
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If cameras or controller are not yet initialized, show a loading indicator
    if (_controller == null || _initializeControllerFuture == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera Example')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Otherwise, build the camera preview once the future completes
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Example')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller!); // Use non-null assertion as we checked above
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_controller!.value.isInitialized) { // Check if controller is fully initialized
            return;
          }
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            final image = await _controller!.takePicture(); // Use non-null assertion

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Picture taken at: ${image.path}')),
            );
            // You can add navigation here to display the image or process it
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error taking picture: $e')),
            );
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}