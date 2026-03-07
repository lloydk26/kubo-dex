import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kubo_dex/core/dependency_injection.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';
import 'package:kubo_dex/features/home/presentation/home_screen/cubits/home_cubit.dart';
import 'package:kubo_dex/features/home/presentation/home_screen/models/home_state.dart';
import 'package:kubo_dex/features/pre_scan/presentation/pre_scan_screen/views/pre_scan_view.dart';
import 'package:kubo_dex/shared/resources/theme.dart';
import 'package:kubo_dex/shared/widgets/app_bottom_nav.dart';
import 'package:kubo_dex/shared/widgets/app_header.dart';
import 'package:kubo_dex/shared/widgets/loading_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.instance<HomeCubit>()..onInitialize(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const LoadingIndicator();
            }
            return _HomeBody(state: state);
          },
        ),
        bottomNavigationBar: AppBottomNav(
          selectedIndex: _selectedNavIndex,
          onTap: (i) => setState(() => _selectedNavIndex = i),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final HomeState state;

  const _HomeBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const AppHeader(),
              const SizedBox(height: 28),
              _Greeting(),
              const SizedBox(height: 32),
              _ScanButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PreScanView()),
                ),
              ),
              const SizedBox(height: 24),
              _StatsRow(
                totalScans: state.totalScans,
                averageGrade: state.averageGrade,
              ),
              const SizedBox(height: 32),
              _RecentScansSection(scans: state.recentScans),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kumusta,',
          style: GoogleFonts.nunito(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.textDark,
            height: 1.1,
          ),
        ),
        Text(
          'Magsasaka',
          style: GoogleFonts.nunito(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.textDark,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _ScanButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ScanButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          shape: const StadiumBorder(),
          elevation: 4,
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
              'SCAN CROP',
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
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int totalScans;
  final String averageGrade;

  const _StatsRow({required this.totalScans, required this.averageGrade});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.eco_rounded,
            iconColor: AppColors.primaryLight,
            label: 'Total Scans',
            value: '$totalScans',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_rounded,
            iconColor: AppColors.gradeA,
            label: 'Average Grade',
            value: averageGrade,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentScansSection extends StatelessWidget {
  final List<ScanRecord> scans;

  const _RecentScansSection({required this.scans});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT SCANS',
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textMuted,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 14),
        if (scans.isEmpty)
          _EmptyScans()
        else
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: scans.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _ScanCard(record: scans[index]),
            ),
          ),
      ],
    );
  }
}

class _ScanCard extends StatelessWidget {
  final ScanRecord record;

  const _ScanCard({required this.record});

  Color get _cropColor {
    return switch (record.cropType) {
      CropType.pechay => AppColors.cropPechay,
      CropType.tomato => AppColors.cropTomato,
      CropType.eggplant => AppColors.cropEggplant,
      CropType.rice => AppColors.cropRice,
      CropType.mais => AppColors.cropMais,
      CropType.other => AppColors.cropOther,
    };
  }

  String get _cropEmoji {
    return switch (record.cropType) {
      CropType.pechay => '🥬',
      CropType.tomato => '🍅',
      CropType.eggplant => '🍆',
      CropType.rice => '🌾',
      CropType.mais => '🌽',
      CropType.other => '🌿',
    };
  }

  Color get _gradeColor {
    return switch (record.grade) {
      CropGrade.a => AppColors.gradeA,
      CropGrade.b => AppColors.gradeB,
      CropGrade.c => AppColors.gradeC,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 82,
              width: double.infinity,
              color: _cropColor.withValues(alpha: 0.25),
              child: Center(
                child: Text(_cropEmoji, style: const TextStyle(fontSize: 38)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          record.cropName,
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _gradeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            record.gradeLabel,
                            style: GoogleFonts.nunito(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('MMM d').format(record.scannedAt),
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
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

class _EmptyScans extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.eco_outlined, size: 40, color: AppColors.textMuted),
          const SizedBox(height: 8),
          Text(
            'No scans yet. Tap Scan Crop to start!',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

