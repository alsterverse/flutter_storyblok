import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? controller;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) return;

    availableCameras().then((cameras) async {
      controller = CameraController(cameras.first, ResolutionPreset.max);
      await controller!.initialize();
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const Text("Camera not available");

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text("Camera!"),
          if (controller?.value.isInitialized == true) Expanded(child: CameraPreview(controller!)),
        ],
      ),
    );
  }
}
