import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

class ResultScreen extends StatefulWidget {
  final String text;

  const ResultScreen({Key? key, required this.text}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textController.text = widget.text;

   /* final myDoc = MutableDocument(
      nodes: [
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(text: 'This is a header'),
          metadata: {
            'blockType': header1Attribution,
          },
        ),
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(text: textController.text),
        ),
      ],
    );

    final docEditor = DocumentEditor(document: myDoc);*/
    return Scaffold(
      appBar: AppBar(
        title: const Text("result"),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: TextField(
            decoration: const InputDecoration(border: InputBorder.none),
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: const TextStyle(color: Colors.black),
            controller: textController),
      ),
    );
  }
}
