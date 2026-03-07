import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kubo_dex/core/dependency_injection.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';
import 'package:kubo_dex/features/pre_scan/presentation/pre_scan_screen/cubits/pre_scan_cubit.dart';
import 'package:kubo_dex/features/pre_scan/presentation/pre_scan_screen/models/pre_scan_state.dart';
import 'package:kubo_dex/features/scanner/presentation/scanner_screen/views/scanner_view.dart';
import 'package:kubo_dex/shared/resources/theme.dart';
import 'package:kubo_dex/shared/widgets/app_drawer.dart';
import 'package:kubo_dex/shared/widgets/app_header.dart';

class PreScanView extends StatelessWidget {
  const PreScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.instance<PreScanCubit>(),
      child: const _PreScanContent(),
    );
  }
}

class _PreScanContent extends StatelessWidget {
  const _PreScanContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: AppDrawer(
        selectedIndex: 0,
        onTap: (i) {
          if (i == 0) Navigator.of(context).popUntil((r) => r.isFirst);
        },
      ),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: AppHeader()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'New Scan',
                    style: GoogleFonts.nunito(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select a crop to scan',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: BlocBuilder<PreScanCubit, PreScanState>(
                builder: (context, state) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Mirror _CropGrid's sizing to derive 1/3 of a grid-item height
                      const crossAxisSpacing = 12.0;
                      const childAspectRatio = 0.95;
                      final itemWidth =
                          (constraints.maxWidth - crossAxisSpacing) / 2;
                      final itemHeight = itemWidth / childAspectRatio;
                      final autoHeight = itemHeight / 3;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AutoCard(
                            height: autoHeight,
                            isSelected: state.isAuto,
                            onTap: () =>
                                context.read<PreScanCubit>().selectAuto(),
                          ),
                          const SizedBox(height: 12),
                          _CropGrid(
                            selectedCrop: state.isAuto
                                ? null
                                : state.selectedCrop,
                            onSelect: (crop) =>
                                context.read<PreScanCubit>().selectCrop(crop),
                          ),
                          const SizedBox(height: 20),
                          const _PhotoTipsCard(),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<PreScanCubit, PreScanState>(
            builder: (context, state) {
              return Container(
                color: AppColors.background,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CaptureToggle(
                      captureMode: state.captureMode,
                      onToggle: (mode) =>
                          context.read<PreScanCubit>().setCaptureMode(mode),
                    ),
                    const SizedBox(height: 14),
                    _OpenCameraButton(
                      enabled: state.canProceed,
                      plant: state.isAuto
                          ? null
                          : state.selectedCrop?.name.toLowerCase(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Auto Card ────────────────────────────────────────────────────────────────

class _AutoCard extends StatelessWidget {
  final double height;
  final bool isSelected;
  final VoidCallback onTap;

  const _AutoCard({
    required this.height,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Row(
            children: [
              // ── Tinted icon strip ───────────────────────────────
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: AppColors.primaryAccent.withValues(alpha: 0.1),
                  child: Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: height * 0.45,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
              ),

              // ── Labels ──────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'AI detects your crop automatically',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Selection indicator ──────────────────────────────
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          key: ValueKey(true),
                          color: AppColors.primary,
                          size: 20,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          key: const ValueKey(false),
                          color: AppColors.textMuted.withValues(alpha: 0.4),
                          size: 20,
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

// ── Crop Grid ────────────────────────────────────────────────────────────────

class _CropGrid extends StatelessWidget {
  final CropType? selectedCrop;
  final ValueChanged<CropType> onSelect;

  const _CropGrid({required this.selectedCrop, required this.onSelect});

  static const _crops = [
    (
      type: CropType.pechay,
      label: 'Pechay',
      emoji: '🥬',
      color: Color(0xFFCFF0CC),
    ),
    (
      type: CropType.tomato,
      label: 'Tomato',
      emoji: '🍅',
      color: Color(0xFFFFDDD8),
    ),
    (
      type: CropType.eggplant,
      label: 'Eggplant',
      emoji: '🍆',
      color: Color(0xFFE8DDFF),
    ),
    (type: CropType.rice, label: 'Rice', emoji: '🌾', color: Color(0xFFFFF3CC)),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: _crops.map((crop) {
        final isSelected = selectedCrop == crop.type;
        return _CropCard(
          label: crop.label,
          emoji: crop.emoji,
          bgColor: crop.color,
          isSelected: isSelected,
          onTap: () => onSelect(crop.type),
        );
      }).toList(),
    );
  }
}

class _CropCard extends StatelessWidget {
  final String label;
  final String emoji;
  final Color bgColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _CropCard({
    required this.label,
    required this.emoji,
    required this.bgColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: bgColor,
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 52)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textMuted.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Photo Tips Card ──────────────────────────────────────────────────────────

class _PhotoTipsCard extends StatelessWidget {
  const _PhotoTipsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Photo-Taking Tips',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          _TipRow(emoji: '☀️', text: 'Ensure good lighting'),
          const SizedBox(height: 6),
          _TipRow(emoji: '🎯', text: 'Focus clearly on the leaf'),
          const SizedBox(height: 6),
          _TipRow(emoji: '🖐️', text: 'Remove other items from view'),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final String emoji;
  final String text;

  const _TipRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 15)),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

// ── Capture Toggle ───────────────────────────────────────────────────────────

class _CaptureToggle extends StatelessWidget {
  final CaptureMode captureMode;
  final ValueChanged<CaptureMode> onToggle;

  const _CaptureToggle({required this.captureMode, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.divider.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _TogglePill(
            label: 'Photo',
            isSelected: captureMode == CaptureMode.photo,
            onTap: () => onToggle(CaptureMode.photo),
          ),
          _TogglePill(
            label: 'Short Video',
            isSelected: captureMode == CaptureMode.video,
            onTap: () => onToggle(CaptureMode.video),
          ),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TogglePill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color: isSelected ? AppColors.textDark : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Open Camera Button ───────────────────────────────────────────────────────

class _OpenCameraButton extends StatelessWidget {
  final bool enabled;
  final String? plant;

  const _OpenCameraButton({required this.enabled, this.plant});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1.0 : 0.45,
        child: ElevatedButton(
          onPressed: enabled
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScannerViewProvider(plant: plant),
                  ),
                )
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary,
            foregroundColor: AppColors.textLight,
            shape: const StadiumBorder(),
            elevation: enabled ? 4 : 0,
            shadowColor: AppColors.primary.withValues(alpha: 0.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 20,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'OPEN CAMERA',
                style: GoogleFonts.nunito(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
