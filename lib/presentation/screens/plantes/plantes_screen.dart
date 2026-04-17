import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/plante_model.dart';
import '../../../providers/plante_provider.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/status_badge.dart';

class PlantesScreen extends ConsumerWidget {
  const PlantesScreen({super.key});

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
      currentRoute: '/plantes',
      userName: 'Salma Ahmed',
      userRole: 'Client',
      body: _PlantesBody(),
    );
  }
}

class _PlantesBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantes = ref.watch(filteredPlantesProvider);
    final query   = ref.watch(searchQueryProvider);

    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Catalogue',
                  style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text('Découvrez nos plantes disponibles',
                  style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGrey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border)),
                      child: TextField(
                        onChanged: (v) => ref
                            .read(searchQueryProvider.notifier).state = v,
                        decoration: InputDecoration(
                          hintText: 'Rechercher une plante...',
                          hintStyle: GoogleFonts.dmSans(
                            fontSize: 13, color: AppColors.textLight),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.textLight, size: 18),
                          suffixIcon: query.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => ref
                                      .read(searchQueryProvider.notifier)
                                      .state = '',
                                  child: const Icon(Icons.close,
                                      color: AppColors.textLight, size: 16))
                              : null,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _showFilter(context, ref),
                    child: Container(
                      height: 46, width: 46,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGrey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border)),
                      child: const Icon(Icons.tune,
                          color: AppColors.textMedium, size: 18)),
                  ),
                ]),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: plantes.when(
              loading: () => _shimmer(),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erreur de chargement',
                      style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => ref.refresh(plantesProvider),
                      child: const Text('Réessayer')),
                  ],
                ),
              ),
              data: (list) => list.isEmpty
                  ? Center(child: Text('Aucune plante trouvée',
                      style: GoogleFonts.dmSans(
                          color: AppColors.textLight, fontSize: 14)))
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: list.length,
                      itemBuilder: (_, i) => PlanteCard(plante: list[i])
                          .animate(delay: (i * 40).ms)
                          .fadeIn().slideY(begin: 0.05),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilter(BuildContext context, WidgetRef ref) {
    final types = ['Arbre', 'Arbuste', 'Fleur', 'Cactus', 'Herbe'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Consumer(builder: (_, ref, __) {
        final selected = ref.watch(selectedTypeProvider);
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filtrer par type',
                style: GoogleFonts.dmSans(
                  fontSize: 15, fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
              const SizedBox(height: 16),
              Wrap(spacing: 8, runSpacing: 8, children: [
                _FilterChip(
                  label: 'Tous',
                  selected: selected == null,
                  onTap: () {
                    ref.read(selectedTypeProvider.notifier).state = null;
                    Navigator.pop(context);
                  }),
                ...types.map((t) => _FilterChip(
                  label: t,
                  selected: selected == t,
                  onTap: () {
                    ref.read(selectedTypeProvider.notifier).state = t;
                    Navigator.pop(context);
                  })),
              ]),
            ],
          ),
        );
      }),
    );
  }

  Widget _shimmer() => GridView.builder(
    padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, childAspectRatio: 0.78,
      crossAxisSpacing: 12, mainAxisSpacing: 12),
    itemCount: 6,
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)))),
  );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: selected ? AppColors.primary : AppColors.border)),
      child: Text(label, style: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: selected ? Colors.white : AppColors.textMedium)),
    ),
  );
}

class PlanteCard extends StatelessWidget {
  final PlanteModel plante;
  const PlanteCard({super.key, required this.plante});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/plantes/${plante.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12)),
                child: plante.urlPlante != null
                    ? Image.network(plante.urlPlante!,
                        fit: BoxFit.cover, width: double.infinity,
                        errorBuilder: (_, __, ___) => _placeholder())
                    : _placeholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plante.nomScientifique,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  StatusBadge(plante.typePlante, type: BadgeType.green),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${plante.prix.toStringAsFixed(2)} DT',
                        style: GoogleFonts.dmSans(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                      if (plante.quantiteStock == 0)
                        StatusBadge('Épuisé', type: BadgeType.red),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: AppColors.accentLight,
    child: Center(child: Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle))),
  );
}