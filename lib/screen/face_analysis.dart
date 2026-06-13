import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../component /app_colors.dart';

class FaceAnalysisScreen extends StatefulWidget {
  const FaceAnalysisScreen({super.key});

  @override
  State<FaceAnalysisScreen> createState() => _FaceAnalysisScreenState();
}

class _FaceAnalysisScreenState extends State<FaceAnalysisScreen> with SingleTickerProviderStateMixin {
  // Logic & Camera State
  late AnimationController _animationController;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  // Real-time Detection State
  String _liveShapeResult = "Align your face in the frame";
  bool _scanComplete = false;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _initializeLiveCamera();
  }

  Future<void> _initializeLiveCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: kIsWeb ? ImageFormatGroup.jpeg : ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();

      if (!mounted) return;
      setState(() => _isCameraInitialized = true);

      // Start the real-time image stream
      _cameraController!.startImageStream((CameraImage image) {
        if (!_isProcessing && !_scanComplete) {
          _isProcessing = true;
          _processLiveFrame(image);
        }
      });
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  Future<void> _processLiveFrame(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final cameraDescription = _cameraController!.description;
      final metadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotationValue.fromRawValue(cameraDescription.sensorOrientation) ?? InputImageRotation.rotation0deg,
        format: InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.yuv420,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, metadata: metadata);
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        _updateUI("Looking for face...");
        return;
      }

      final Face face = faces.first;
      final points = face.contours[FaceContourType.face]?.points;

      if (points == null || points.length < 20) {
        _updateUI("Mapping contours...");
        return;
      }

      // Calculate Proportions
      final left = points.reduce((a, b) => a.x < b.x ? a : b);
      final right = points.reduce((a, b) => a.x > b.x ? a : b);
      final top = points.reduce((a, b) => a.y < b.y ? a : b);
      final bottom = points.reduce((a, b) => a.y > b.y ? a : b);

      double width = (right.x - left.x).abs().toDouble();
      double height = (bottom.y - top.y).abs().toDouble();
      double ratio = height / (width == 0 ? 1 : width);

      if (ratio > 1.45) {
        _updateUI("Oval Structure Detected", complete: true);
      } else if (ratio < 1.25) {
        _updateUI("Round Structure Detected", complete: true);
      } else {
        _updateUI("Heart Structure Detected", complete: true);
      }
    } catch (e) {
      debugPrint("Processing error: $e");
    } finally {
      _isProcessing = false;
    }
  }

  void _updateUI(String message, {bool complete = false}) {
    if (mounted) {
      setState(() {
        _liveShapeResult = message;
        if (complete) {
          _scanComplete = true;
          _animationController.stop();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Live Feed
          Positioned.fill(
            child: _isCameraInitialized
                ? AspectRatio(aspectRatio: _cameraController!.value.aspectRatio, child: CameraPreview(_cameraController!))
                : const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),

          // UI Overlays
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.3))),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                _buildScannerFrame(),
                const Spacer(),
                _buildStatusCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
          const Text("Live Facial Analysis", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildScannerFrame() {
    return Center(
      child: Container(
        width: 280,
        height: 380,
        decoration: BoxDecoration(
          border: Border.all(color: _scanComplete ? Colors.green : AppColors.sharpPink, width: 2),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Stack(
          children: [
            if (!_scanComplete)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Positioned(
                  top: _animationController.value * 380,
                  left: 0,
                  right: 0,
                  child: Container(height: 4, decoration: BoxDecoration(color: AppColors.sharpPink, boxShadow: [BoxShadow(color: AppColors.sharpPink.withOpacity(0.8), blurRadius: 20, spreadRadius: 4)])),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      child: Column(
        children: [
          Text(_liveShapeResult, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          if (_scanComplete)
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.sharpPink),
                onPressed: () => Navigator.pop(context),
                child: const Text("Unlock Ritual Map", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          else
            const CircularProgressIndicator(color: AppColors.sharpPink),
        ],
      ),
    );
  }
}