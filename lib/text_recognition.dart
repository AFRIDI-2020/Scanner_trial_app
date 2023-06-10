import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanners/result_screen.dart';

enum UserPermission { cameraPermissionGranted, cameraPermissionDenied, cameraPermissionPermanentlyDenied }

class TextRecognition extends StatefulWidget {
  const TextRecognition({Key? key}) : super(key: key);

  @override
  State<TextRecognition> createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> with WidgetsBindingObserver {
  UserPermission userPermission = UserPermission.cameraPermissionDenied;

  late final Future<void> _future;
  CameraController? _cameraController;
  final _textRecognizer = TextRecognizer();

  Future<void> _requestPermission() async {
    var status = await Permission.camera.request();

    if (status.isDenied) {
      userPermission = UserPermission.cameraPermissionDenied;
      status = await Permission.camera.request();
      return;
    }

    if (status.isPermanentlyDenied) {
      userPermission = UserPermission.cameraPermissionPermanentlyDenied;
      openAppSettings();
      return;
    }

    if (status.isGranted) {
      userPermission = UserPermission.cameraPermissionGranted;
    }
    setState(() {});
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _future = _requestPermission();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (userPermission == UserPermission.cameraPermissionGranted)
              FutureBuilder(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);
                    return Center(
                      child: CameraPreview(_cameraController!),
                    );
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text("Text Recognition"),
                elevation: 0,
              ),
              backgroundColor: userPermission == UserPermission.cameraPermissionGranted ? Colors.transparent : null,
              body: userPermission == UserPermission.cameraPermissionGranted
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: ElevatedButton(
                            onPressed: _scanImage,
                            child: const Text("Scan Text"),
                          ),
                        )
                      ],
                    )
                  : const Center(
                      child: Text("Permission denied"),
                    ),
            ),
          ],
        );
      },
    );
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    CameraDescription? camera;

    for (int i = 0; i < cameras.length; i++) {
      CameraDescription current = cameras[i];

      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(camera, ResolutionPreset.max, enableAudio: false);

    await _cameraController?.initialize();

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    print("scanning");
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      print("scanning");
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);

      final recognizedText = await _textRecognizer.processImage(inputImage);

      await navigator.push(MaterialPageRoute(builder: (context) => ResultScreen(text: recognizedText.text)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }
}
