import 'package:flutter/material.dart';
import 'package:scanners/pdf_scanner.dart';

class DocumentScannerView extends StatefulWidget {
  const DocumentScannerView({Key? key}) : super(key: key);

  @override
  State<DocumentScannerView> createState() => _DocumentScannerViewState();
}

class _DocumentScannerViewState extends State<DocumentScannerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Scanner"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PdfScanner()));
          },
          child: const Text("Scan"),
        ),
      ),
    );
  }
}
