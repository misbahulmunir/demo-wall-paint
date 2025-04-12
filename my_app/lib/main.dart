import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Wall Paint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ARWallPaintPage(),
    );
  }
}

class ARWallPaintPage extends StatefulWidget {
  const ARWallPaintPage({super.key});

  @override
  State<ARWallPaintPage> createState() => _ARWallPaintPageState();
}

class _ARWallPaintPageState extends State<ARWallPaintPage> {
  late ARKitController arkitController;
  Color selectedColor = Colors.blue;
  List<ARKitNode> paintedWalls = [];

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onNodeTap = (nodes) => _handleTap(nodes);
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required for AR')),
        );
      }
    }
  }

  void _handleTap(List<String> nodesList) {
    final newNode = ARKitNode(
      geometry: ARKitBox(
        width: 0.2,
        height: 0.2,
        length: 0.2,
        materials: [
          ARKitMaterial(
            diffuse: ARKitMaterialProperty.color(selectedColor),
          ),
        ],
      ),
      position: vector.Vector3(0, 0, -2.0),
      rotation: vector.Vector4(0, 0, 0, 1),
    );

    arkitController.add(newNode);
    setState(() {
      paintedWalls.add(newNode);
    });
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Wall Paint'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _showColorPicker,
          ),
        ],
      ),
      body: ARKitSceneView(
        enableTapRecognizer: true,
        onARKitViewCreated: onARKitViewCreated,
        planeDetection: ARPlaneDetection.horizontalAndVertical,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          for (var node in paintedWalls) {
            arkitController.remove(node.name);
          }
          setState(() {
            paintedWalls.clear();
          });
        },
        tooltip: 'Clear all walls',
        child: const Icon(Icons.clear_all),
      ),
    );
  }
}
