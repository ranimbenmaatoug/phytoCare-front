import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: GoogleFonts.dmSans(
      fontSize: 11, fontWeight: FontWeight.w500,
      color: AppColors.textLight, letterSpacing: 0.06,
    ),
  );
}