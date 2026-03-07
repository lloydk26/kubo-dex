import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kubo_dex/core/dependency_injection.dart';
import 'package:kubo_dex/features/diagnosis/domain/entities/diagnosis_result.dart';
import 'package:kubo_dex/features/diagnosis/presentation/diagnosis_screen/cubits/diagnosis_cubit.dart';
import 'package:kubo_dex/features/diagnosis/presentation/diagnosis_screen/models/diagnosis_state.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';
import 'package:kubo_dex/shared/resources/theme.dart';
import 'package:kubo_dex/shared/widgets/app_header.dart';

class DiagnosisView extends StatelessWidget {
  final DiagnosisResult result;

  const DiagnosisView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.instance<DiagnosisCubit>(),
      child: _DiagnosisContent(result: result),
    );
  }
}

class _DiagnosisContent extends StatelessWidget {
  final DiagnosisResult result;

  const _DiagnosisContent({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── App Header ────────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: AppHeader(),
              ),
              const SizedBox(height: 20),

              // ── Crop Identity Banner ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _CropIdentityBanner(result: result),
              ),
              const SizedBox(height: 16),

              // ── Flavor text ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  '\u2018${result.flavorText}\u2019',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Health Status Card ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _HealthStatusCard(result: result),
              ),
              const SizedBox(height: 16),

              // ── Recommendations Card ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _RecommendationsCard(result: result),
              ),
              const SizedBox(height: 24),

              // ── Back to Home ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: _BackToHomeButton(
                  onPressed: () => Navigator.of(context)
                      .popUntil((route) => route.isFirst),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Crop Identity Banner ──────────────────────────────────────────────────────

class _CropIdentityBanner extends StatelessWidget {
  final DiagnosisResult result;

  const _CropIdentityBanner({required this.result});

  String get _cropEmoji => switch (result.cropType) {
        CropType.pechay => '🥬',
        CropType.tomato => '🍅',
        CropType.eggplant => '🍆',
        CropType.rice => '🌾',
        CropType.mais => '🌽',
        CropType.other => '🌿',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_cropEmoji, style: const TextStyle(fontSize: 72)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u2018${result.cropName.toUpperCase()}\u2019',
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _BannerPill(
                      label: result.cropCategory,
                      color: Colors.white.withValues(alpha: 0.25),
                      textColor: Colors.white,
                    ),
                    _BannerPill(
                      label: _healthLabel(result.healthStatus),
                      color: _healthColor(result.healthStatus),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _healthLabel(HealthStatus s) => switch (s) {
        HealthStatus.healthy => 'Healthy',
        HealthStatus.needsImproving => 'Needs Improving',
        HealthStatus.critical => 'Critical',
      };

  Color _healthColor(HealthStatus s) => switch (s) {
        HealthStatus.healthy => AppColors.gradeA,
        HealthStatus.needsImproving => AppColors.gradeB,
        HealthStatus.critical => AppColors.gradeC,
      };
}

class _BannerPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _BannerPill({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

// ── Health Status Card ────────────────────────────────────────────────────────

class _HealthStatusCard extends StatelessWidget {
  final DiagnosisResult result;

  const _HealthStatusCard({required this.result});

  String get _statusLabel => switch (result.healthStatus) {
        HealthStatus.healthy => 'Healthy',
        HealthStatus.needsImproving => 'Needs Improving',
        HealthStatus.critical => 'Critical',
      };

  Color get _statusColor => switch (result.healthStatus) {
        HealthStatus.healthy => AppColors.gradeA,
        HealthStatus.needsImproving => AppColors.gradeB,
        HealthStatus.critical => AppColors.gradeC,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: _statusColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              _statusLabel,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${result.confidencePercent}% confidence',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.summary,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recommendations Card ──────────────────────────────────────────────────────

class _RecommendationsCard extends StatelessWidget {
  final DiagnosisResult result;

  const _RecommendationsCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Text(
              'WHAT YOU CAN DO',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
                color: AppColors.textDark,
              ),
            ),
          ),

          // Recommendation items
          ...result.recommendations.map(
            (item) => _RecommendationRow(item: item),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // Harvest estimate
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Text(
                  'Harvest Estimate',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(
                    '${result.harvestDays} days',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // Feedback row
          BlocBuilder<DiagnosisCubit, DiagnosisState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _FeedbackButton(
                        label: '👍  Helpful',
                        isSelected: state.feedbackHelpful == true,
                        onTap: () =>
                            context.read<DiagnosisCubit>().submitFeedback(true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeedbackButton(
                        label: '👎  Not Helpful',
                        isSelected: state.feedbackHelpful == false,
                        onTap: () => context
                            .read<DiagnosisCubit>()
                            .submitFeedback(false),
                      ),
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

class _RecommendationRow extends StatelessWidget {
  final RecommendationItem item;

  const _RecommendationRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.action,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.timeline,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FeedbackButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ── Back to Home Button ───────────────────────────────────────────────────────

class _BackToHomeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackToHomeButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_back_rounded, size: 20),
            const SizedBox(width: 10),
            Text(
              'Back to Home',
              style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
