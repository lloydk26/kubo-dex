import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kubo_dex/core/dependency_injection.dart';
import 'package:kubo_dex/features/weather/domain/entities/location_permission_status.dart';
import 'package:kubo_dex/features/weather/domain/entities/weather_forecast.dart';
import 'package:kubo_dex/features/weather/presentation/weather_forecast_card/cubits/weather_forecast_card_cubit.dart';
import 'package:kubo_dex/features/weather/presentation/weather_forecast_card/models/weather_forecast_card_state.dart';
import 'package:kubo_dex/shared/resources/theme.dart';

// ── Colors specific to the weather card ──────────────────────────────────────

const _kDivider = Color(0xFFE5E7EB);
const _kGood = Color(0xFF22C55E);
const _kCaution = Color(0xFFF59E0B);
const _kDanger = Color(0xFFEF4444);
const _kTodayBg = Color(0xFFF0FDF4);

// ── Public entry point ───────────────────────────────────────────────────────

class WeatherForecastCard extends StatelessWidget {
  const WeatherForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ServiceLocator.instance<WeatherForecastCardCubit>()..onInitialize(),
      child: BlocBuilder<WeatherForecastCardCubit, WeatherForecastCardState>(
        builder: (context, state) {
          // Waiting for or showing the native permission dialog
          if (state.permissionStatus == LocationPermissionStatus.unknown ||
              state.permissionStatus == LocationPermissionStatus.requesting) {
            return const _CardSkeleton();
          }

          // User denied location — show actionable banner
          if (state.permissionStatus == LocationPermissionStatus.denied) {
            return _LocationPermissionBanner(
              onTap: () => context
                  .read<WeatherForecastCardCubit>()
                  .retryLocationPermission(),
            );
          }

          // Granted but still fetching
          if (state.isLoading) return const _CardSkeleton();

          // Error or no data — hide gracefully
          if (state.hasError || state.isEmpty) return const SizedBox.shrink();

          return _ForecastCard(state: state);
        },
      ),
    );
  }
}

// ── Full card ────────────────────────────────────────────────────────────────

class _ForecastCard extends StatelessWidget {
  final WeatherForecastCardState state;

  const _ForecastCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final selected = state.selected!;
    final tip = _getWeatherTip(selected.temperature);

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
          _CardHeader(forecasts: state.forecasts),
          const SizedBox(height: 12),
          _TodayHighlight(
            forecast: selected,
            isToday: state.selectedIndex == 0,
          ),
          const _HDivider(),
          _AlertTip(tip: tip),
          const _HDivider(),
          _ForecastStrip(
            forecasts: state.forecasts,
            selectedIndex: state.selectedIndex,
            onSelect: (i) =>
                context.read<WeatherForecastCardCubit>().selectDay(i),
          ),
        ],
      ),
    );
  }
}

// ── Row 1 — Header ────────────────────────────────────────────────────────────

class _CardHeader extends StatelessWidget {
  final List<DailyForecast> forecasts;

  const _CardHeader({required this.forecasts});

  String get _dateRange {
    if (forecasts.isEmpty) return '';
    final first = DateFormat('MMM d').format(forecasts.first.day);
    final last = DateFormat('MMM d').format(forecasts.last.day);
    return '$first – $last';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.wb_sunny_outlined, color: AppColors.primary, size: 14),
        const SizedBox(width: 6),
        Text(
          "YOUR FARM'S FORECAST",
          style: GoogleFonts.nunito(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 1.2,
          ),
        ),
        const Spacer(),
        Text(
          _dateRange,
          style: GoogleFonts.nunito(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

// ── Row 2 — Selected day highlight ────────────────────────────────────────────

class _TodayHighlight extends StatelessWidget {
  final DailyForecast forecast;
  final bool isToday;

  const _TodayHighlight({required this.forecast, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: label + emoji + description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isToday
                    ? 'Today'
                    : DateFormat('EEEE, MMM d').format(forecast.day),
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${_weatherEmoji(forecast.weather)}  ${forecast.description}',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Right: temperature
        Text(
          '${forecast.temperature.toStringAsFixed(1)}°C',
          style: GoogleFonts.nunito(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

// ── Row 3 — Alert tip ─────────────────────────────────────────────────────────

class _AlertTip extends StatelessWidget {
  final _WeatherTip tip;

  const _AlertTip({required this.tip});

  Color get _dotColor => switch (tip.level) {
    _TipLevel.good => _kGood,
    _TipLevel.caution => _kCaution,
    _TipLevel.danger => _kDanger,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip.text,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Row 4 — Multi-day forecast strip ──────────────────────────────────────────

class _ForecastStrip extends StatelessWidget {
  final List<DailyForecast> forecasts;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _ForecastStrip({
    required this.forecasts,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(forecasts.length, (i) {
            final f = forecasts[i];
            final isSelected = i == selectedIndex;
            final isToday = i == 0;

            return GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 62,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: isSelected ? _kTodayBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                        )
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isToday ? 'Today' : DateFormat('EEE').format(f.day),
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textMuted,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _weatherEmoji(f.weather),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${f.temperature.round()}°C',
                      style: GoogleFonts.nunito(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 16,
                      height: 2,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Location permission banner ────────────────────────────────────────────────

class _LocationPermissionBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _LocationPermissionBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kCaution),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: _kCaution,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enable location for farm forecasts',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Tap to update your location settings',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton loader ───────────────────────────────────────────────────────────

class _CardSkeleton extends StatefulWidget {
  const _CardSkeleton();

  @override
  State<_CardSkeleton> createState() => _CardSkeletonState();
}

class _CardSkeletonState extends State<_CardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// ── Shared divider ────────────────────────────────────────────────────────────

class _HDivider extends StatelessWidget {
  const _HDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: _kDivider, height: 1, thickness: 1);
  }
}

// ── Weather helpers ───────────────────────────────────────────────────────────

String _weatherEmoji(String weather) {
  return switch (weather) {
    'sunny' => '☀️',
    'partly_sunny' => '⛅',
    'cloudy' => '☁️',
    'rain' => '🌧️',
    'thunderstorm' => '⛈️',
    _ => '🌤️',
  };
}

enum _TipLevel { good, caution, danger }

class _WeatherTip {
  final _TipLevel level;
  final String text;

  const _WeatherTip({required this.level, required this.text});
}

_WeatherTip _getWeatherTip(double temperature) {
  if (temperature > 35) {
    return const _WeatherTip(
      level: _TipLevel.danger,
      text: 'Heat stress risk today — increase watering frequency for your crops',
    );
  }
  if (temperature > 30) {
    return const _WeatherTip(
      level: _TipLevel.caution,
      text: 'Warm conditions today — monitor soil moisture closely',
    );
  }
  if (temperature < 20) {
    return const _WeatherTip(
      level: _TipLevel.good,
      text: 'Cool conditions today — ideal for leafy crop growth',
    );
  }
  return const _WeatherTip(
    level: _TipLevel.good,
    text: 'Good growing conditions today — ideal time to fertilize',
  );
}
