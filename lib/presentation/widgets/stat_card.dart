import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: GoogleFonts.dmSans(
              fontSize: 11, color: AppColors.textLight,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.05)),
          const SizedBox(height: 6),
          Text(value,
            style: GoogleFonts.dmSans(
              fontSize: 24, color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              height: 1)),
          const SizedBox(height: 4),
          Text(unit,
            style: GoogleFonts.dmSans(
              fontSize: 11, color: AppColors.textLight)),
          const SizedBox(height: 10),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}