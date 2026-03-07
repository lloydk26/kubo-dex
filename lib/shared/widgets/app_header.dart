import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/images/logo.svg',
          width: MediaQuery.sizeOf(context).width * 0.38,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
