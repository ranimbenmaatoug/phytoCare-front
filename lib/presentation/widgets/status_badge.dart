import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

enum BadgeType { green, amber, red, gray }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;

  const StatusBadge(this.label, {super.key, this.type = BadgeType.green});

  @override
  Widget build(BuildContext context) {
    final colors = {
      BadgeType.green: (const Color(0xFFEAF7EC), const Color(0xFF1B5E2E)),
      BadgeType.amber: (const Color(0xFFFAEEDA), const Color(0xFF854F0B)),
      BadgeType.red:   (const Color(0xFFFCEBEB), const Color(0xFFA32D2D)),
      BadgeType.gray:  (AppColors.surfaceGrey,   AppColors.textLight),
    };
    final (bg, fg) = colors[type]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
        style: GoogleFonts.dmSans(
          fontSize: 10, fontWeight: FontWeight.w500, color: fg)),
    );
  }
}