import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/plante_provider.dart';
import '../../../providers/panier_provider.dart';

class PlanteDetailScreen extends ConsumerWidget {
  final int planteId;
  const PlanteDetailScreen({super.key, required this.planteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plante = ref.watch(planteDetailProvider(planteId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: plante.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (p) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: p.urlPlante != null
                    ? Image.network(p.urlPlante!, fit: BoxFit.cover)
                    : Container(color: AppColors.accent,
                        child: const Icon(Icons.eco,
                            color: AppColors.primary, size: 80)),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(p.nomScientifique,
                            style: Theme.of(context).textTheme.headlineMedium),
                        ),
                        Text('${p.prix.toStringAsFixed(2)} DT',
                          style: const TextStyle(color: AppColors.primary,
                              fontSize: 22, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(p.typePlante,
                        style: const TextStyle(color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 20),
                    Text('Description',
                      style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(p.description,
                      style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 20),

                    // Infos plante
                    _InfoGrid(plante: p),
                    const SizedBox(height: 32),

                    // Stock
                    Row(children: [
                      Icon(
                        p.quantiteStock > 0 ? Iconsax.tick_circle : Iconsax.close_circle,
                        color: p.quantiteStock > 0 ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        p.quantiteStock > 0
                            ? '${p.quantiteStock} en stock'
                            : 'Rupture de stock',
                        style: TextStyle(
                          color: p.quantiteStock > 0 ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: p.quantiteStock > 0 ? () {
                        ref.read(panierProvider.notifier).ajouterAuPanier(p, 1);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Ajouté au panier ! 🛒'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      } : null,
                      icon: const Icon(Iconsax.shopping_cart),
                      label: const Text('Ajouter au panier'),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final dynamic plante;
  const _InfoGrid({required this.plante});

  @override
  Widget build(BuildContext context) {
    final infos = [
      if (plante.besoinEau != null)
        {'icon': Iconsax.drop, 'label': 'Eau', 'value': plante.besoinEau},
      if (plante.tempOptimale != null)
        {'icon': Iconsax.sun_1, 'label': 'Temp.', 'value': plante.tempOptimale},
      if (plante.saisonPlantation != null)
        {'icon': Iconsax.calendar, 'label': 'Saison', 'value': plante.saisonPlantation},
    ];
    if (infos.isEmpty) return const SizedBox();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 10,
        mainAxisSpacing: 10, childAspectRatio: 1.1,
      ),
      itemCount: infos.length,
      itemBuilder: (_, i) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceGrey,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(infos[i]['icon'] as IconData,
                color: AppColors.primary, size: 22),
            const SizedBox(height: 4),
            Text(infos[i]['value'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11,
                  fontWeight: FontWeight.w600, color: AppColors.textDark)),
            Text(infos[i]['label'] as String,
              style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}