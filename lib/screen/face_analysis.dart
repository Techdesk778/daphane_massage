import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../component /app_colors.dart';

class FaceAnalysisScreen extends StatefulWidget {
  const FaceAnalysisScreen({super.key});

  @override
  State<FaceAnalysisScreen> createState() => _FaceAnalysisScreenState();
}

class _FaceAnalysisScreenState extends State<FaceAnalysisScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isAnalyzing = true;
  String _statusMessage = "Position your face in the frame";

  @override
  void initState() {
    super.initState();

    // 1. Initialize Scanning Animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // 2. Initialize Camera (Web & Mobile optimized)
    _initializeCamera();

    // 3. Start Analysis Simulation
    _startAnalysisSimulation();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint("No cameras found");
        return;
      }

      // Find the front camera, fallback to first available
      CameraDescription selectedCamera = cameras.first;
      for (var camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          selectedCamera = camera;
          break;
        }
      }

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg, // Better cross-platform support
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  void _startAnalysisSimulation() async {
    // Stage 1: Initial position
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() => _statusMessage = "Analyzing structural contours...");

    // Stage 2: Mapping
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() => _statusMessage = "Mapping facial muscle tension...");

    // Stage 3: Completion
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _statusMessage = "Analysis Complete!";
      });
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Live Camera Feed
          Positioned.fill(
            child: _isCameraInitialized && _cameraController != null
                ? AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            )
                : const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),

          // 2. High-Tech Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // 3. UI Layer
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text("AI Face Scan",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const Spacer(),

                // Scanning Frame & Laser Line
                Center(
                  child: Container(
                    width: 280,
                    height: 380,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: _isAnalyzing ? AppColors.sharpPink : Colors.green,
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Stack(
                      children: [
                        if (_isAnalyzing)
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Positioned(
                                top: _animationController.value * 380,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.sharpPink,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.sharpPink.withOpacity(0.8),
                                          blurRadius: 20,
                                          spreadRadius: 4
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Bottom Status Card
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _statusMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!_isAnalyzing)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sharpPink),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("View Target Map",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        )
                      else
                        const CircularProgressIndicator(color: AppColors.sharpPink),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}