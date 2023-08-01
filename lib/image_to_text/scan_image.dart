import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photogpt/constants/app_methods.dart';
import 'package:photogpt/widgets/spacing.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ScanImageScreen extends StatefulWidget {
  ScanImageScreen({required this.image, super.key});

  File image;

  @override
  State<ScanImageScreen> createState() => _ScanImageScreenState();
}

class _ScanImageScreenState extends State<ScanImageScreen> {
  bool _isScanning = false;
  String _scannedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.file(widget.image),
                  ),
                  height(10),
                  Row(
                    children: [
                      Expanded(
                          child: OutlinedButton(
                              onPressed: () async {
                                File? img = await AppMethods.pickImage(source: ImageSource.gallery);
                                if (img != null) {
                                  setState(() {
                                    widget.image = img;
                                  });
                                }
                              },
                              child: const Text('Use Another Image'))),
                      width(10),
                      Expanded(
                          child:
                              FilledButton(onPressed: _scanImage, child: const Text('Scan Text')))
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor:
                    ColorScheme.fromSeed(seedColor: Theme.of(context).colorScheme.primary)
                        .secondaryContainer,
                centerTitle: true,
                title: const Text(
                  'Scan Results',
                ),
                leading: Container(),
              ),
              body: SingleChildScrollView(
                child: Center(
                    child: _isScanning
                        ? const CircularProgressIndicator()
                        : Text(_scannedText.isEmpty ? 'Hit the Scan Text Button' : _scannedText)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _scanImage() async {
    setState(() {
      _isScanning = true;
    });
    final inputImage = InputImage.fromFile(widget.image);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    String scannedText = '';

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText += '${line.text}\n';
      }
    }
    setState(() {
      _isScanning = false;
      _scannedText = scannedText;
    });
  }
}
