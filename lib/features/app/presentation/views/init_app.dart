import 'package:flutter/material.dart';
import 'package:kubo_dex/features/home/presentation/home_screen/views/home_view.dart';
import 'package:kubo_dex/shared/resources/theme.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class InitApp extends StatelessWidget {
  const InitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kubo Dex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      navigatorObservers: [routeObserver],
      home: const HomeView(),
    );
  }
}
