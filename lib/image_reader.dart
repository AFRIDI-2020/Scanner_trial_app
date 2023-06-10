import 'package:flutter/material.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'package:learning_text_recognition/learning_text_recognition.dart';

class ImageReader extends StatefulWidget {
  const ImageReader({Key? key}) : super(key: key);

  @override
  State<ImageReader> createState() => _ImageReaderState();
}

class _ImageReaderState extends State<ImageReader> {
  final TextRecognition _textRecognition = TextRecognition();
  RecognizedText? _data;

  Future<void> _startRecognition(InputImage image) async {
    _data = await _textRecognition.process(image);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Image Reader'),
      // ),
      body: InputCameraView(
        mode: InputCameraMode.gallery,
        // resolutionPreset: ResolutionPreset.high,
        title: 'Text Recognition',
        onImage: _startRecognition,
        overlay: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Text(
              _data != null ? _data!.text : "no text",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
