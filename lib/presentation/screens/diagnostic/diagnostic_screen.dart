import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/status_badge.dart';

class DiagnosticScreen extends ConsumerStatefulWidget {
  const DiagnosticScreen({super.key});
  @override
  ConsumerState<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends ConsumerState<DiagnosticScreen> {
  bool _loading = false;
  bool _hasResult = false;

  static const _nav = [
    NavItem(label: 'Accueil',    route: '/home'),
    NavItem(label: 'Catalogue',  route: '/plantes'),
    NavItem(label: 'Panier',     route: '/panier'),
    NavItem(label: 'Commandes',  route: '/commandes'),
    NavItem(label: 'Diagnostic', route: '/diagnostic'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      navItems: _nav,
      currentRoute: '/diagnostic',
      userName: 'Salma Ahmed',
      userRole: 'Client',
      body: _buildBody(),
    );
  }

  Widget _buildBody() => Container(
    color: AppColors.background,
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diagnostic IA',
              style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text('Analysez votre plante par photo',
              style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGrey,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(14)),
                child: Column(children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      shape: BoxShape.circle),
                    child: Center(child: Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.primaryLight, width: 2),
                        shape: BoxShape.circle)))),
                  const SizedBox(height: 16),
                  Text('Photographiez votre plante',
                    style: GoogleFonts.dmSans(
                      fontSize: 14, fontWeight: FontWeight.w500,
                      color: AppColors.textDark)),
                  const SizedBox(height: 6),
                  Text(
                    'Uploadez une photo claire de la plante malade.\nLe modèle IA analyse l\'image et génère le diagnostic.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 12, color: AppColors.textLight,
                      height: 1.5)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8)),
                    child: Text('Choisir une image',
                      style: GoogleFonts.dmSans(
                        color: Colors.white, fontSize: 13,
                        fontWeight: FontWeight.w500)),
                  ),
                ]),
              ),
            ).animate().fadeIn(duration: 400.ms),

            if (_loading) ...[
              const SizedBox(height: 32),
              Center(child: Column(children: [
                const CircularProgressIndicator(
                    color: AppColors.primary, strokeWidth: 2),
                const SizedBox(height: 12),
                Text('Analyse en cours...',
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: AppColors.textLight)),
              ])),
            ],

            if (_hasResult && !_loading) ...[
              const SizedBox(height: 32),
              _buildResult(),
            ],
          ],
        ),
      ),
    ),
  );

  Widget _buildResult() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Résultat du diagnostic',
        style: GoogleFonts.dmSans(
          fontSize: 14, fontWeight: FontWeight.w600,
          color: AppColors.textDark)),
      const SizedBox(height: 14),

      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              left: BorderSide(color: AppColors.primaryLight, width: 3)),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mildiou détecté',
                style: GoogleFonts.dmSans(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
              const StatusBadge('87% confiance', type: BadgeType.green),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: 0.87,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(
                  AppColors.primaryLight),
              minHeight: 4)),
          const SizedBox(height: 14),
          Text(
            'Signes de mildiou détectés sur les feuilles. Recommandations : retirer les feuilles affectées, appliquer un fongicide à base de cuivre, améliorer la ventilation autour de la plante.',
            style: GoogleFonts.dmSans(
              fontSize: 12, color: AppColors.textMedium,
              height: 1.6)),
        ]),
      ).animate().fadeIn().slideY(begin: 0.05),
      const SizedBox(height: 20),

      Text('Plantes recommandées',
        style: GoogleFonts.dmSans(
          fontSize: 13, fontWeight: FontWeight.w600,
          color: AppColors.textDark)),
      const SizedBox(height: 10),

      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Lavande Officinale',
                style: GoogleFonts.dmSans(
                  fontSize: 13, fontWeight: FontWeight.w500,
                  color: AppColors.textDark)),
              Text('Répulsif naturel · 8.00 DT',
                style: GoogleFonts.dmSans(
                    fontSize: 11, color: AppColors.textLight)),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8)),
              child: Text('Voir',
                style: GoogleFonts.dmSans(
                  color: Colors.white, fontSize: 12,
                  fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 100.ms),
    ],
  );

  Future<void> _pickImage() async {
    setState(() { _loading = true; _hasResult = false; });
    await Future.delayed(const Duration(seconds: 2));
    setState(() { _loading = false; _hasResult = true; });
  }
}