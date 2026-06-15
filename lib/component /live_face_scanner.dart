import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../component /app_colors.dart';

class LiveFaceScannerScreen extends StatefulWidget {
  const LiveFaceScannerScreen({super.key});

  @override
  State<LiveFaceScannerScreen> createState() => _LiveFaceScannerScreenState();
}

class _LiveFaceScannerScreenState extends State<LiveFaceScannerScreen> {
  CameraController? _cameraController;
  bool _isProcessing = false;
  String _liveShapeResult = "Align your face in the camera view";

  // Initialize the native ML Kit Face Detector with structural contours enabled
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      performanceMode: FaceDetectorMode.accurate, // FIXED: Changed 'mode' to 'performanceMode'
    ),
  );

  @override
  void initState() {
    super.initState();
    _initializeLiveCamera();
  }

  Future<void> _initializeLiveCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;

      await _cameraController!.startImageStream((CameraImage image) {
        if (!_isProcessing) {
          _isProcessing = true;
          _processLiveFrame(image);
        }
      });

      setState(() {});
    } catch (e) {
      setState(() {
        _liveShapeResult = "Camera access configuration error.";
      });
    }
  }

  Future<void> _processLiveFrame(CameraImage image) async {
    try {
      // Concatenate planes into a single byte buffer
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final cameraDescription = _cameraController!.description;
      final imageRotation = InputImageRotationValue.fromRawValue(cameraDescription.sensorOrientation)
          ?? InputImageRotation.rotation0deg;
      final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw)
          ?? InputImageFormat.yuv420;

      // FIXED: Using InputImageMetadata instead of deprecated InputImageData
      final metadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, metadata: metadata);

      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        _updateResultText("Looking for face...");
        return;
      }

      final Face face = faces.first;
      // Using .face as a fallback if specific contours are not detected
      final faceContour = face.contours[FaceContourType.face];

      if (faceContour == null || faceContour.points.length < 20) {
        _updateResultText("Mapping coordinates...");
        return;
      }

      final points = faceContour.points;

      // --- CALCULATE GEOMETRIC FACE SHAPE ---
      final leftPoint = points.reduce((a, b) => a.x < b.x ? a : b);
      final rightPoint = points.reduce((a, b) => a.x > b.x ? a : b);
      final topPoint = points.reduce((a, b) => a.y < b.y ? a : b);
      final bottomPoint = points.reduce((a, b) => a.y > b.y ? a : b);

      double width = (rightPoint.x - leftPoint.x).abs().toDouble();
      double height = (bottomPoint.y - topPoint.y).abs().toDouble();

      if (width == 0) width = 1.0;
      double ratio = height / width;

      if (ratio > 1.5) {
        _updateResultText("Oval Structure (Balanced & Proportional)");
      } else if (ratio < 1.2) {
        _updateResultText("Round Shape (Soft & Balanced)");
      } else {
        _updateResultText("Heart Shape (Structured & Defined)");
      }
    } catch (e) {
      debugPrint("Analysis Error: $e");
    } finally {
      _isProcessing = false;
    }
  }

  void _updateResultText(String message) {
    if (mounted) {
      setState(() {
        _liveShapeResult = message;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Live facial Scanner", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.sharpPink.withOpacity(0.5), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: _cameraController != null && _cameraController!.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  )
                      : const Center(
                    child: CircularProgressIndicator(color: AppColors.sharpPink),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "LIVE FACE SHAPE TRACKER",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _liveShapeResult,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}