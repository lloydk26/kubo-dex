import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kubo_dex/core/dependency_injection.dart';
import 'package:kubo_dex/features/diagnosis/presentation/diagnosis_screen/views/diagnosis_view.dart';
import 'package:kubo_dex/features/scanner/presentation/scanner_screen/cubits/scanner_cubit.dart';
import 'package:kubo_dex/features/scanner/presentation/scanner_screen/models/scanner_state.dart';
import 'package:kubo_dex/shared/resources/theme.dart';

class ScannerView extends StatefulWidget {
  final String? plant;

  const ScannerView({super.key, this.plant});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  CameraController? _controller;
  bool _isInitialized = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _initError = 'No camera found on this device.');
        return;
      }
      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      _controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _isInitialized = true);
      if (mounted) {
        context.read<ScannerCubit>().onCameraReady();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _initError = e.toString());
        context.read<ScannerCubit>().onCameraError(e.toString());
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScannerCubit, ScannerState>(
      listenWhen: (prev, curr) =>
          (curr.isDone && !prev.isDone) || (curr.hasError && !prev.hasError),
      listener: (context, state) {
        if (state.isDone && state.result != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DiagnosisView(result: state.result!),
            ),
          );
        } else if (state.hasError && state.error != null) {
          final cubit = context.read<ScannerCubit>();
          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red.shade700,
                  action: SnackBarAction(
                    label: 'Ulit',
                    textColor: Colors.white,
                    onPressed: cubit.retryCapture,
                  ),
                ),
              )
              .closed
              .then((reason) {
            // The action button already called retryCapture directly;
            // for every other dismissal (timeout, swipe, hide) trigger it here.
            if (reason != SnackBarClosedReason.action) {
              cubit.retryCapture();
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_initError != null) {
      return _CameraErrorView(message: _initError!);
    }
    if (!_isInitialized || _controller == null) {
      return const _CameraLoadingView();
    }
    return BlocBuilder<ScannerCubit, ScannerState>(
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // ── Full-screen camera preview ──────────────────────────────
            _FullScreenCamera(controller: _controller!),

            // ── Processing blur overlay ─────────────────────────────────
            if (state.isProcessing)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.black.withValues(alpha: 0.55)),
                ),
              ),

            // ── Corner bracket focus box ────────────────────────────────
            Center(child: _FocusBox(dimmed: state.isProcessing)),

            // ── Processing spinner + text ───────────────────────────────
            if (state.isProcessing) const _ProcessingOverlay(),

            // ── Nudge pills (ready state only) ──────────────────────────
            if (state.isReady)
              Positioned(
                top: MediaQuery.paddingOf(context).top + 72,
                left: 20,
                right: 20,
                child: _NudgePill(text: state.currentNudge),
              ),

            // ── Header overlay ──────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _HeaderOverlay(onBack: () => Navigator.pop(context)),
            ),

            // ── Shutter button ──────────────────────────────────────────
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: _ShutterButton(
                  enabled: state.isReady,
                  onPressed: () {
                    final cubit = context.read<ScannerCubit>();
                    final plant = widget.plant;
                    _controller?.takePicture().then((file) {
                      if (mounted) {
                        cubit.capturePhoto(file.path, plant: plant);
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Provider wrapper (used by navigation) ────────────────────────────────────

class ScannerViewProvider extends StatelessWidget {
  final String? plant;

  const ScannerViewProvider({super.key, this.plant});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.instance<ScannerCubit>(),
      child: ScannerView(plant: plant),
    );
  }
}

// ── Full-screen Camera ────────────────────────────────────────────────────────

class _FullScreenCamera extends StatelessWidget {
  final CameraController controller;
  const _FullScreenCamera({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final scale =
        1 / (controller.value.aspectRatio * (size.width / size.height));

    return ClipRect(
      child: Transform.scale(
        scale: scale < 1 ? 1 / scale : scale,
        child: Center(child: CameraPreview(controller)),
      ),
    );
  }
}

// ── Focus Box with corner brackets ───────────────────────────────────────────

class _FocusBox extends StatelessWidget {
  final bool dimmed;
  const _FocusBox({required this.dimmed});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width * 0.72;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: dimmed ? 0.4 : 1.0,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _CornerBracketPainter()),
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 28.0;
    final w = size.width;
    final h = size.height;

    // Top-left
    canvas.drawLine(const Offset(0, len), Offset.zero, paint);
    canvas.drawLine(Offset.zero, Offset(len, 0), paint);

    // Top-right
    canvas.drawLine(Offset(w - len, 0), Offset(w, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, len), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, h - len), Offset(0, h), paint);
    canvas.drawLine(Offset(0, h), Offset(len, h), paint);

    // Bottom-right
    canvas.drawLine(Offset(w - len, h), Offset(w, h), paint);
    canvas.drawLine(Offset(w, h - len), Offset(w, h), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Processing overlay ────────────────────────────────────────────────────────

class _ProcessingOverlay extends StatelessWidget {
  const _ProcessingOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _DotsSpinner(),
          const SizedBox(height: 24),
          Text(
            'Analyzing crop health...',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Processing image',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Grade and recommendations coming soon',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotsSpinner extends StatefulWidget {
  const _DotsSpinner();

  @override
  State<_DotsSpinner> createState() => _DotsSpinnerState();
}

class _DotsSpinnerState extends State<_DotsSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        size: const Size(64, 64),
        painter: _DotsPainter(_controller.value),
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  final double progress;
  _DotsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const dotCount = 12;
    const dotRadius = 3.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - dotRadius * 2;

    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * pi - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      final rel = ((i / dotCount) - progress + 1.0) % 1.0;
      final opacity = (1.0 - rel).clamp(0.15, 1.0);
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_DotsPainter old) => old.progress != progress;
}

// ── Nudge pill ────────────────────────────────────────────────────────────────

class _NudgePill extends StatelessWidget {
  final String text;
  const _NudgePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: Container(
        key: ValueKey(text),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}

// ── Header overlay ────────────────────────────────────────────────────────────

class _HeaderOverlay extends StatelessWidget {
  final VoidCallback onBack;
  const _HeaderOverlay({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.55), Colors.transparent],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shutter button ────────────────────────────────────────────────────────────

class _ShutterButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _ShutterButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.3),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Icon(
          Icons.camera_alt_rounded,
          color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.5),
          size: 30,
        ),
      ),
    );
  }
}

// ── Loading / Error states ────────────────────────────────────────────────────

class _CameraLoadingView extends StatelessWidget {
  const _CameraLoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),
          Text(
            'Starting camera...',
            style: GoogleFonts.nunito(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _CameraErrorView extends StatelessWidget {
  final String message;
  const _CameraErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white54,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              'Camera unavailable',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Go back',
                style: GoogleFonts.nunito(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
