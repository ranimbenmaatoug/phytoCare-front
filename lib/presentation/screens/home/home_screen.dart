import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/section_label.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _nav = [
    NavItem(label: 'Accueil',    route: '/home'),
    NavItem(label: 'Catalogue',  route: '/plantes'),
    NavItem(label: 'Panier',     route: '/panier'),
    NavItem(label: 'Commandes',  route: '/commandes'),
    NavItem(label: 'Diagnostic', route: '/diagnostic'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppShell(
      navItems: _nav,
      currentRoute: '/home',
      userName: 'Salma Ahmed',
      userRole: 'Client',
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tableau de bord',
              style: Theme.of(context).textTheme.headlineMedium,
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 4),
            Text('Bienvenue sur PhytoCare',
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 28),

            // Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PÉPINIÈRE EN LIGNE',
                    style: GoogleFonts.dmSans(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 10, letterSpacing: 0.08,
                      fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Trouvez la plante\nqui vous correspond',
                    style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 20,
                      fontWeight: FontWeight.w600, height: 1.3)),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => context.go('/plantes'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8)),
                      child: Text('Voir le catalogue',
                        style: GoogleFonts.dmSans(
                          color: Colors.white, fontSize: 13,
                          fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.05),
            const SizedBox(height: 24),

            // Stats
            Row(children: const [
              Expanded(child: StatCard(
                  label: 'Panier', value: '2', unit: 'articles')),
              SizedBox(width: 10),
              Expanded(child: StatCard(
                  label: 'Commandes', value: '5', unit: 'total')),
              SizedBox(width: 10),
              Expanded(child: StatCard(
                  label: 'En cours', value: '1', unit: 'livraison')),
            ]).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 28),

            SectionLabel('Accès rapide'),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _Card(
                title: 'Catalogue',
                subtitle: 'Parcourir les plantes',
                onTap: () => context.go('/plantes'))),
              const SizedBox(width: 12),
              Expanded(child: _Card(
                title: 'Diagnostic IA',
                subtitle: 'Analyser une photo',
                onTap: () => context.go('/diagnostic'))),
            ]).animate().fadeIn(delay: 250.ms),
            const SizedBox(height: 28),

            SectionLabel('Mon compte'),
            const SizedBox(height: 14),

            // Profil client
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border)),
              child: Column(children: [
                Row(children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      shape: BoxShape.circle),
                    child: Center(child: Text('SA',
                      style: GoogleFonts.dmSans(
                        color: AppColors.primary, fontSize: 16,
                        fontWeight: FontWeight.w600)))),
                  const SizedBox(width: 14),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Salma Ahmed',
                        style: GoogleFonts.dmSans(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                      Text('salma@email.com',
                        style: GoogleFonts.dmSans(
                          fontSize: 12, color: AppColors.textLight)),
                    ],
                  )),
                ]),
                const SizedBox(height: 14),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          context.go('/profil/modifier?role=CLIENT'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8)),
                        child: Center(child: Text('Modifier le profil',
                          style: GoogleFonts.dmSans(
                            color: Colors.white, fontSize: 13,
                            fontWeight: FontWeight.w500))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.go('/commandes'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGrey,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border)),
                        child: Center(child: Text('Mes commandes',
                          style: GoogleFonts.dmSans(
                            color: AppColors.textDark, fontSize: 13,
                            fontWeight: FontWeight.w500))),
                      ),
                    ),
                  ),
                ]),
              ]),
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
}
class _Card extends StatelessWidget {
  final String title, subtitle;
  final VoidCallback onTap;
  const _Card({required this.title, required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 28, height: 28,
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(6)),
          child: Center(child: Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle)))),
        const SizedBox(height: 10),
        Text(title, style: GoogleFonts.dmSans(
          fontSize: 13, fontWeight: FontWeight.w600,
          color: AppColors.textDark)),
        const SizedBox(height: 2),
        Text(subtitle, style: GoogleFonts.dmSans(
          fontSize: 11, color: AppColors.textLight)),
      ]),
    ),
  );
}