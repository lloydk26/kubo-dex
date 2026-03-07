import 'dart:io';

class AnalyzeCropRequestContract {
  final File image;
  final String? plant;

  const AnalyzeCropRequestContract({
    required this.image,
    this.plant,
  });
}
