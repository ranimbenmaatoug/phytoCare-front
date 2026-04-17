import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/panier_provider.dart';
import '../../widgets/app_shell.dart';

class PanierScreen extends ConsumerWidget {
  const PanierScreen({super.key});

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
      currentRoute: '/panier',
      userName: 'Salma Ahmed',
      userRole: 'Client',
      body: _PanierBody(),
    );
  }
}

class _PanierBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items    = ref.watch(panierProvider);
    final notifier = ref.read(panierProvider.notifier);

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Mon panier',
                    style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text('${items.length} article(s)',
                    style: Theme.of(context).textTheme.bodyMedium),
                ]),
                if (items.isNotEmpty)
                  GestureDetector(
                    onTap: () => _confirmVider(context, notifier),
                    child: Text('Vider',
                      style: GoogleFonts.dmSans(
                        fontSize: 13, color: AppColors.error,
                        fontWeight: FontWeight.w500)),
                  ),
              ],
            ),
          ),

          if (items.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        shape: BoxShape.circle),
                      child: Center(child: Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.primaryLight, width: 2),
                          shape: BoxShape.circle)))),
                    const SizedBox(height: 16),
                    Text('Votre panier est vide',
                      style: GoogleFonts.dmSans(
                        fontSize: 15, fontWeight: FontWeight.w500,
                        color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text('Ajoutez des plantes depuis le catalogue',
                      style: GoogleFonts.dmSans(
                          fontSize: 13, color: AppColors.textLight)),
                  ],
                ).animate().fadeIn(),
              ),
            )
          else ...[
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final item = items[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border)),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: item.plante.urlPlante != null
                            ? Image.network(item.plante.urlPlante!,
                                width: 60, height: 60, fit: BoxFit.cover)
                            : Container(
                                width: 60, height: 60,
                                color: AppColors.accentLight,
                                child: Center(child: Container(
                                  width: 20, height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    shape: BoxShape.circle)))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.plante.nomScientifique,
                            style: GoogleFonts.dmSans(
                              fontSize: 13, fontWeight: FontWeight.w500,
                              color: AppColors.textDark)),
                          Text('${item.plante.prix.toStringAsFixed(2)} DT',
                            style: GoogleFonts.dmSans(
                              fontSize: 12, color: AppColors.primary,
                              fontWeight: FontWeight.w500)),
                        ])),
                      Row(children: [
                        _QtyBtn(
                          icon: Icons.remove,
                          onTap: () => notifier.changerQuantite(
                              item.plante.id!, item.quantite - 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('${item.quantite}',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppColors.textDark))),
                        _QtyBtn(
                          icon: Icons.add,
                          onTap: () => notifier.changerQuantite(
                              item.plante.id!, item.quantite + 1)),
                      ]),
                    ]),
                  ).animate(delay: (i * 50).ms).fadeIn().slideX(begin: 0.03);
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: AppColors.border))),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                      style: GoogleFonts.dmSans(
                        fontSize: 14, color: AppColors.textMedium)),
                    Text(
                      '${notifier.total.toStringAsFixed(2)} DT',
                      style: GoogleFonts.dmSans(
                        fontSize: 22, fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity, height: 48,
                  child: ElevatedButton(
                    onPressed: () => _confirmerCommande(context, notifier),
                    child: const Text('Passer la commande')),
                ),
              ]),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmVider(BuildContext context, PanierNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        title: Text('Vider le panier ?',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600, color: AppColors.textDark)),
        content: Text('Cette action est irréversible.',
          style: GoogleFonts.dmSans(color: AppColors.textLight)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler',
              style: GoogleFonts.dmSans(color: AppColors.textMedium))),
          TextButton(
            onPressed: () {
              notifier.viderPanier();
              Navigator.pop(context);
            },
            child: Text('Vider',
              style: GoogleFonts.dmSans(
                color: AppColors.error, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  void _confirmerCommande(BuildContext context, PanierNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        title: Text('Confirmer la commande ?',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600, color: AppColors.textDark)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler',
              style: GoogleFonts.dmSans(color: AppColors.textMedium))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40)),
            onPressed: () {
              notifier.viderPanier();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Commande passée avec succès',
                  style: GoogleFonts.dmSans(color: Colors.white)),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ));
            },
            child: const Text('Confirmer')),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(7)),
      child: Icon(icon, color: AppColors.primary, size: 14)),
  );
}