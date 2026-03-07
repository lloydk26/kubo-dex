import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kubo_dex/core/dependency_injection.dart';
import 'package:kubo_dex/features/app/presentation/views/init_app.dart';
import 'package:kubo_dex/features/home/domain/entities/scan_record.dart';
import 'package:kubo_dex/features/home/presentation/home_screen/cubits/home_cubit.dart';
import 'package:kubo_dex/features/home/presentation/home_screen/models/home_state.dart';
import 'package:kubo_dex/features/pre_scan/presentation/pre_scan_screen/views/pre_scan_view.dart';
import 'package:kubo_dex/features/weather/presentation/weather_forecast_card/cubits/weather_forecast_card_cubit.dart';
import 'package:kubo_dex/features/weather/presentation/weather_forecast_card/views/weather_forecast_card.dart';
import 'package:kubo_dex/shared/resources/theme.dart';
import 'package:kubo_dex/shared/widgets/app_drawer.dart';
import 'package:kubo_dex/shared/widgets/app_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with RouteAware {
  int _selectedNavIndex = 0;
  late final WeatherForecastCardCubit _weatherCubit;
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _weatherCubit =
        ServiceLocator.instance<WeatherForecastCardCubit>()..onInitialize();
    _homeCubit = ServiceLocator.instance<HomeCubit>()..onInitialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _homeCubit.loadDashboard();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _weatherCubit.close();
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeCubit),
        BlocProvider.value(value: _weatherCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        endDrawer: AppDrawer(
          selectedIndex: _selectedNavIndex,
          onTap: (i) => setState(() => _selectedNavIndex = i),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => _HomeBody(state: state),
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
      child: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () => context.read<WeatherForecastCardCubit>().refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                if (state.isLoading)
                  const _StatsRowSkeleton()
                else
                  _StatsRow(
                    totalScans: state.totalScans,
                    averageGrade: state.averageGrade,
                  ),
                const SizedBox(height: 16),
                if (state.isLoading)
                  const _RecentScansSkeleton()
                else
                  _RecentScansSection(scans: state.recentScans),
                const SizedBox(height: 24),
                const WeatherForecastCard(),
                const SizedBox(height: 24),
                const _ComingSoonSection(),
                const SizedBox(height: 24),
              ],
            ),
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

class _StatsRowSkeleton extends StatefulWidget {
  const _StatsRowSkeleton();

  @override
  State<_StatsRowSkeleton> createState() => _StatsRowSkeletonState();
}

class _StatsRowSkeletonState extends State<_StatsRowSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Row(
        children: [
          Expanded(child: _SkeletonStatCard(opacity: _opacity.value)),
          const SizedBox(width: 12),
          Expanded(child: _SkeletonStatCard(opacity: _opacity.value)),
        ],
      ),
    );
  }
}

class _SkeletonStatCard extends StatelessWidget {
  final double opacity;

  const _SkeletonStatCard({required this.opacity});

  @override
  Widget build(BuildContext context) {
    final fill = AppColors.textMuted.withValues(alpha: opacity);
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
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 10,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 36,
                height: 20,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int totalScans;
  final String averageGrade;

  const _StatsRow({required this.totalScans, required this.averageGrade});

  Color get _gradeColor => switch (averageGrade) {
        'A' => AppColors.gradeA,
        'B' => AppColors.gradeB,
        'C' => AppColors.gradeC,
        _ => AppColors.textMuted,
      };

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
            iconColor: _gradeColor,
            label: 'Average Grade',
            value: averageGrade,
            valueColor: _gradeColor,
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
  final Color? valueColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
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
                  color: valueColor ?? AppColors.textDark,
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

class _RecentScansSkeleton extends StatefulWidget {
  const _RecentScansSkeleton();

  @override
  State<_RecentScansSkeleton> createState() => _RecentScansSkeletonState();
}

class _RecentScansSkeletonState extends State<_RecentScansSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        AnimatedBuilder(
          animation: _opacity,
          builder: (_, __) => SizedBox(
            height: 160,
            child: Row(
              children: [
                _SkeletonScanCard(opacity: _opacity.value),
                const SizedBox(width: 12),
                _SkeletonScanCard(opacity: _opacity.value),
                const SizedBox(width: 12),
                _SkeletonScanCard(opacity: _opacity.value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkeletonScanCard extends StatelessWidget {
  final double opacity;

  const _SkeletonScanCard({required this.opacity});

  @override
  Widget build(BuildContext context) {
    final fill = AppColors.textMuted.withValues(alpha: opacity);
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
            Container(height: 82, color: fill),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 70,
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 44,
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(4),
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

// ── Coming Soon Section ───────────────────────────────────────────────────────

class _ComingSoonSection extends StatelessWidget {
  const _ComingSoonSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "WHAT'S COMING",
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textMuted,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 14),
        const _MarketplaceCard(),
        const SizedBox(height: 12),
        const _SmartFarmCard(),
      ],
    );
  }
}

// ── Marketplace Card ──────────────────────────────────────────────────────────

class _MarketplaceCard extends StatelessWidget {
  const _MarketplaceCard();

  @override
  Widget build(BuildContext context) {
    return const _ComingSoonCard(
      accentColor: Color(0xFFF7FEE7),
      emoji: '🛒',
      title: 'KuboDex Marketplace',
      description:
          'Sell your harvest directly to buyers — priced by quality, powered by your scan data.',
      pills: [
        _FeaturePill(label: '🏷️  Quality-based pricing'),
        _FeaturePill(label: '🚜  Direct to buyer'),
        _FeaturePill(label: '📦  Grade-verified listings'),
      ],
      notifyMessage: "We'll let you know when Marketplace launches!",
    );
  }
}

// ── Smart Farm Card ───────────────────────────────────────────────────────────

class _SmartFarmCard extends StatelessWidget {
  const _SmartFarmCard();

  @override
  Widget build(BuildContext context) {
    return const _ComingSoonCard(
      accentColor: Color(0xFFF0FDF4),
      emoji: '📡',
      title: 'Smart Farm Intelligence',
      description:
          'Connect IoT soil sensors for personalized crop rotation, planting schedules, and treatment plans.',
      pills: [
        _FeaturePill(label: '🌡️  Soil monitoring'),
        _FeaturePill(label: '🔄  Crop rotation plans'),
        _FeaturePill(label: '📅  Planting schedules'),
      ],
      notifyMessage:
          "We'll let you know when Smart Farm Intelligence launches!",
    );
  }
}

// ── Shared card shell ─────────────────────────────────────────────────────────

class _ComingSoonCard extends StatelessWidget {
  final Color accentColor;
  final String emoji;
  final String title;
  final String description;
  final List<_FeaturePill> pills;
  final String notifyMessage;

  const _ComingSoonCard({
    required this.accentColor,
    required this.emoji,
    required this.title,
    required this.description,
    required this.pills,
    required this.notifyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ComingSoonBadge(),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pills,
                ),
                const SizedBox(height: 16),
                _NotifyMeButton(message: notifyMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── COMING SOON badge ─────────────────────────────────────────────────────────

class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('✨', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Text(
            'COMING SOON',
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFD97706),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Feature pill ──────────────────────────────────────────────────────────────

class _FeaturePill extends StatelessWidget {
  final String label;

  const _FeaturePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

// ── Notify Me button ──────────────────────────────────────────────────────────

class _NotifyMeButton extends StatelessWidget {
  final String message;

  const _NotifyMeButton({required this.message});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.55,
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  message,
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Notify Me When Live',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
