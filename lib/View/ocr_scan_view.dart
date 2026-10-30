import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../Services/ocr_service.dart';

class OCRScanView extends StatefulWidget {
  const OCRScanView({super.key});

  @override
  State<OCRScanView> createState() => _OCRScanViewState();
}

class _OCRScanViewState extends State<OCRScanView> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isProcessing = false;
  final OCRService _ocrService = OCRService();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.high);
      await _controller?.initialize();
      if (mounted) setState(() {});
    }
  }

  Future<void> _captureAndScan() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final XFile image = await _controller!.takePicture();
      final result = await _ocrService.processImageForBP(image.path);

      if (mounted) {
        // Return parsed numbers back to previous screen
        Navigator.pop(context, {
          'systolic': result.systolic,
          'diastolic': result.diastolic,
          'pulse': result.pulse,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning image: $e')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scan BP Monitor')),
      body: Stack(
        children: [
          // Live camera preview filling background
          Positioned.fill(child: CameraPreview(_controller!)),

          // Accessibility Overlay Box (Guides user where to frame monitor digits)
          Center(
            child: Container(
              width: 280,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.tealAccent, width: 3),
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withValues(alpha: 0.1),
              ),
              child: const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Align screen numbers inside box',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, backgroundColor: Colors.black54),
                  ),
                ),
              ),
            ),
          ),

          // Loading indicator overlay during OCR analysis
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text('Reading numbers...', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _isProcessing ? null : _captureAndScan,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}