import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/status_badge.dart';

class CommandesScreen extends StatelessWidget {
  const CommandesScreen({super.key});

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
      currentRoute: '/commandes',
      userName: 'Salma Ahmed',
      userRole: 'Client',
      body: _CommandesBody(),
    );
  }
}

class _CommandesBody extends StatelessWidget {
  final _commandes = const [
    {'id': '#005', 'date': '10/04/2026', 'montant': '68.50 DT',
     'statut': 'En transit', 'type': BadgeType.amber},
    {'id': '#004', 'date': '02/04/2026', 'montant': '45.00 DT',
     'statut': 'Livrée', 'type': BadgeType.green},
    {'id': '#003', 'date': '20/03/2026', 'montant': '120.00 DT',
     'statut': 'Livrée', 'type': BadgeType.green},
    {'id': '#002', 'date': '10/03/2026', 'montant': '28.00 DT',
     'statut': 'Livrée', 'type': BadgeType.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mes commandes',
              style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text('Historique de vos achats',
              style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ..._commandes.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _CommandeCard(
                id: e.value['id'] as String,
                date: e.value['date'] as String,
                montant: e.value['montant'] as String,
                statut: e.value['statut'] as String,
                badgeType: e.value['type'] as BadgeType,
              ).animate(delay: (e.key * 60).ms).fadeIn().slideY(begin: 0.05),
            )),
          ],
        ),
      ),
    );
  }
}

class _CommandeCard extends StatelessWidget {
  final String id, date, montant, statut;
  final BadgeType badgeType;
  const _CommandeCard({required this.id, required this.date,
      required this.montant, required this.statut,
      required this.badgeType});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border)),
    child: Row(children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceGrey,
          borderRadius: BorderRadius.circular(8)),
        child: Center(child: Container(
          width: 16, height: 16,
          decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.primaryLight, width: 2),
            borderRadius: BorderRadius.circular(3))))),
      const SizedBox(width: 14),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Commande $id',
            style: GoogleFonts.dmSans(
              fontSize: 13, fontWeight: FontWeight.w500,
              color: AppColors.textDark)),
          const SizedBox(height: 2),
          Text(date, style: GoogleFonts.dmSans(
              fontSize: 11, color: AppColors.textLight)),
        ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(montant, style: GoogleFonts.dmSans(
          fontSize: 14, fontWeight: FontWeight.w600,
          color: AppColors.textDark)),
        const SizedBox(height: 4),
        StatusBadge(statut, type: badgeType),
      ]),
    ]),
  );
}