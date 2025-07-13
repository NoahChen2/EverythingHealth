import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class NutritionService {
  late Interpreter _interpreter;
  static const int _inputSize = 260;
  // The labels must match the order of your model's output
  final List<String> _labels = [
    "grams", "calories_100g", "carbs_100g",
    "protein_100g", "fat_100g", "sugar_100g"
  ];

  /// Loads the TFLite model from assets.
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/NutritionModel_260_float16.tflite');
    } catch (e) {
      print("Failed to load model: $e");
    }
  }

  /// Preprocesses the image to the format the model expects.
  Uint8List _preprocessImage(Uint8List imageData) {
    img.Image? originalImage = img.decodeImage(imageData);
    img.Image resizedImage = img.copyResize(originalImage!, width: _inputSize, height: _inputSize);

    // Convert the image to a Float32List of normalized pixel values.
    // The mobile app provides FP32 input, and the TFLite delegate handles
    // the conversion to FP16 on the device.
    var inputBytes = Float32List(1 * _inputSize * _inputSize * 3);
    var bufferIndex = 0;
    for (var y = 0; y < _inputSize; y++) {
      for (var x = 0; x < _inputSize; x++) {
        var pixel = resizedImage.getPixel(x, y);
        inputBytes[bufferIndex++] = pixel.r / 255.0;
        inputBytes[bufferIndex++] = pixel.g / 255.0;
        inputBytes[bufferIndex++] = pixel.b / 255.0;
      }
    }
    return inputBytes.buffer.asUint8List();
  }

  /// Runs inference on the processed image and returns the results.
  Future<Map<String, double>> analyzeImage(Uint8List imageBytes) async {
    // Prepare the input and output tensors.
    var input = _preprocessImage(imageBytes).buffer.asFloat32List().reshape([1, _inputSize, _inputSize, 3]);
    var output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);

    // Run inference
    _interpreter.run(input, output);

    // Process the output into a readable map.
    final List<double> results = output[0];
    return Map.fromIterables(_labels, results);
  }

  Map<String, double> getMeans() {
    return {
    'grams': 236.84901902389032, 
    'calories_100g': 155.00570810032548, 
    'carbs_100g': 10.757664772136243, 
    'protein_100g': 11.51432999746936, 
    'fat_100g': 7.685602644136834, 
    'sugar_100g': 2.5149272622612355
    };
  }

  Map<String, double> getStdDevs() {
    return {
      'grams': 181.21267853710106, 
      'calories_100g': 95.30823156436207, 
      'carbs_100g': 8.678065313341422, 
      'protein_100g': 8.262360477256278, 
      'fat_100g': 7.648909966293577, 
      'sugar_100g': 3.2624425897884057
    };
  }

  /// Closes the interpreter to free up resources.
  void dispose() {
    _interpreter.close();
  }
}