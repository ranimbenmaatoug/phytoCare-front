import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/section_label.dart';
import '../../widgets/status_badge.dart';

class VendeurScreen extends ConsumerStatefulWidget {
  const VendeurScreen({super.key});
  @override
  ConsumerState<VendeurScreen> createState() => _VendeurScreenState();
}

class _VendeurScreenState extends ConsumerState<VendeurScreen> {
  int _idx = 0;
  Map<String, dynamic>? _selectedCommande;
  String _filtreCommande = 'Toutes';  
  String _filtrePlante = 'Toutes'; 
  final _labels = [
    'Tableau de bord', 'Mes plantes', 'Commandes', 'Profil'
  ];
  
  final _plantesMock = [
    {'nom': 'Cactus Saguaro', 'type': 'Cactus',
     'stock': 12, 'prix': 12.50,
     'badge': BadgeType.green, 'badgeLabel': 'Actif'},
    {'nom': 'Palmier Areca', 'type': 'Arbre',
     'stock': 3, 'prix': 45.00,
     'badge': BadgeType.amber, 'badgeLabel': 'Stock faible'},
    {'nom': 'Lavande Officinale', 'type': 'Aromatique',
     'stock': 0, 'prix': 8.00,
     'badge': BadgeType.red, 'badgeLabel': 'Épuisé'},
    {'nom': 'Monstera Deliciosa', 'type': 'Tropicale',
     'stock': 8, 'prix': 28.00,
     'badge': BadgeType.green, 'badgeLabel': 'Actif'},
    {'nom': 'Ficus Lyrata', 'type': 'Arbre d\'intérieur',
     'stock': 2, 'prix': 55.00,
     'badge': BadgeType.amber, 'badgeLabel': 'Stock faible'},
  ];
  

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final sidebar = _buildSidebar();

    if (isWide) {
      return Scaffold(
        body: Row(children: [
          SizedBox(width: 220, child: sidebar),
          Expanded(child: _buildContent()),
        ]),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.sidebarBg, elevation: 0,
        leading: Builder(builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 20),
          onPressed: () => Scaffold.of(ctx).openDrawer())),
        title: Text('PhytoCare', style: GoogleFonts.dmSans(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      drawer: Drawer(width: 220, backgroundColor: AppColors.sidebarBg,
          child: sidebar),
      body: _buildContent(),
    );
  }

  Widget _buildSidebar() {
    return Container(
      color: AppColors.sidebarBg,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8))),
            const SizedBox(height: 10),
            Text('PhytoCare', style: GoogleFonts.dmSans(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            Text('Espace vendeur', style: GoogleFonts.dmSans(
              color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
          ]),
        ),
        const Divider(color: Colors.white12, height: 1),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: _labels.asMap().entries.map((e) {
              final isActive = _idx == e.key;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _idx = e.key;
                    _selectedCommande = null;
                  });
                  if (MediaQuery.of(context).size.width <= 700) {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryLight.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    Container(width: 6, height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? AppColors.primaryLight
                            : Colors.white.withValues(alpha: 0.2))),
                    const SizedBox(width: 12),
                    Text(e.value, style: GoogleFonts.dmSans(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontWeight: isActive
                          ? FontWeight.w500 : FontWeight.w400)),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(color: Colors.white12, height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryLight, shape: BoxShape.circle),
              child: Center(child: Text('KB', style: GoogleFonts.dmSans(
                color: Colors.white, fontSize: 12,
                fontWeight: FontWeight.w600)))),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Karim Belhaj', style: GoogleFonts.dmSans(
                  color: Colors.white, fontSize: 13,
                  fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis),
                Text('Vendeur', style: GoogleFonts.dmSans(
                  color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
              ],
            )),
            GestureDetector(
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
              child: Icon(Icons.logout_rounded,
                color: Colors.white.withValues(alpha: 0.4), size: 18)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildContent() {
    switch (_idx) {
      case 0: return _buildDashboard();
      case 1: return _buildPlantes();
      case 2: return _selectedCommande != null
          ? _buildCommandeDetail(_selectedCommande!)
          : _buildCommandes();
      case 3: return _buildProfil();
      default: return _buildDashboard();
    }
  }

  // ─── DASHBOARD ────────────────────────────────────────────────────────────
  Widget _buildDashboard() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Tableau de bord',
        style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 4),
      Text('Gestion du catalogue et des commandes',
        style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 28),
      Row(children: const [
        Expanded(child: StatCard(label: 'Plantes gérées',
            value: '42', unit: 'références')),
        SizedBox(width: 10),
        Expanded(child: StatCard(label: 'À valider',
            value: '18', unit: 'commandes')),
        SizedBox(width: 10),
        Expanded(child: StatCard(label: 'Stock faible',
            value: '5', unit: 'références')),
      ]).animate().fadeIn(),
      const SizedBox(height: 28),
      SectionLabel('Actions rapides'),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: _ActionCard(
          title: 'Ajouter une plante',
          subtitle: 'Nouveau produit',
          onTap: () => context.go('/vendeur/ajouter'))),
        const SizedBox(width: 12),
        Expanded(child: _ActionCard(
          title: 'Valider commandes',
          subtitle: '18 en attente',
          onTap: () => setState(() { _idx = 2; _selectedCommande = null; }))),
      ]).animate().fadeIn(delay: 100.ms),
      const SizedBox(height: 28),
      SectionLabel('Commandes récentes'),
      const SizedBox(height: 14),
      ..._commandesMock.take(2).map((c) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _CommandeRow(
          commande: c,
          onTap: () => setState(() {
            _idx = 2;
            _selectedCommande = c;
          }),
        ),
      )),
    ]),
  );

  // ─── PLANTES ──────────────────────────────────────────────────────────────
 Widget _buildPlantes() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Mes plantes',
          style: Theme.of(context).textTheme.headlineMedium),
        GestureDetector(
          onTap: () => context.go('/vendeur/ajouter'),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8)),
            child: Text('+ Ajouter', style: GoogleFonts.dmSans(
              color: Colors.white, fontSize: 13,
              fontWeight: FontWeight.w500)),
          ),
        ),
      ]),
      const SizedBox(height: 12),

      // Recherche
      Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border)),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Rechercher une plante...',
            hintStyle: GoogleFonts.dmSans(
                fontSize: 13, color: AppColors.textLight),
            prefixIcon: const Icon(Icons.search,
                color: AppColors.textLight, size: 18),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12)),
        ),
      ),
      const SizedBox(height: 12),

      // Filtres
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _FilterChip(label: 'Toutes',
            selected: _filtrePlante == 'Toutes',
            onTap: () => setState(() => _filtrePlante = 'Toutes')),
          const SizedBox(width: 8),
          _FilterChip(label: 'Actives',
            selected: _filtrePlante == 'Actif',
            onTap: () => setState(() => _filtrePlante = 'Actif')),
          const SizedBox(width: 8),
          _FilterChip(label: 'Stock faible',
            selected: _filtrePlante == 'Stock faible',
            onTap: () => setState(() => _filtrePlante = 'Stock faible')),
          const SizedBox(width: 8),
          _FilterChip(label: 'Épuisées',
            selected: _filtrePlante == 'Épuisé',
            onTap: () => setState(() => _filtrePlante = 'Épuisé')),
        ]),
      ),
      const SizedBox(height: 16),

      // Liste filtrée
      ..._plantesMock
        .where((p) => _filtrePlante == 'Toutes' ||
            p['badgeLabel'] == _filtrePlante)
        .toList()
        .asMap()
        .entries
        .map((e) {
          final p = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PlanteRow(
              nom: p['nom'] as String, type: p['type'] as String,
              stock: p['stock'] as int, prix: p['prix'] as double,
              badge: p['badge'] as BadgeType, badgeLabel: p['badgeLabel'] as String,
              onModifier: () => context.go(
                  '/vendeur/modifier/${e.key + 1}'),
              onSupprimer: () => _confirmSupprimer(p['nom'] as String),
            ).animate(delay: (e.key * 50).ms)
                .fadeIn().slideY(begin: 0.05),
          );
        }),

      if (_plantesMock.where((p) => _filtrePlante == 'Toutes' ||
          p['badgeLabel'] == _filtrePlante).isEmpty)
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text('Aucune plante dans cette catégorie',
              style: GoogleFonts.dmSans(
                fontSize: 13, color: AppColors.textLight)),
          ),
        ),
    ]),
  );

Widget _buildCommandes() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Commandes',
        style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 4),
      Text('Cliquez sur une commande pour voir les détails',
        style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 16),

      // Recherche
      Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border)),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Rechercher une commande...',
            hintStyle: GoogleFonts.dmSans(
                fontSize: 13, color: AppColors.textLight),
            prefixIcon: const Icon(Icons.search,
                color: AppColors.textLight, size: 18),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12)),
        ),
      ),
      const SizedBox(height: 12),

      // Filtres
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _FilterChip(
            label: 'Toutes',
            selected: _filtreCommande == 'Toutes',
            onTap: () => setState(() => _filtreCommande = 'Toutes')),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'En attente',
            selected: _filtreCommande == 'En attente',
            onTap: () => setState(() => _filtreCommande = 'En attente')),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Acceptées',
            selected: _filtreCommande == 'Acceptée',
            onTap: () => setState(() => _filtreCommande = 'Acceptée')),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Refusées',
            selected: _filtreCommande == 'Refusée',
            onTap: () => setState(() => _filtreCommande = 'Refusée')),
        ]),
      ),
      const SizedBox(height: 16),

      // Liste filtrée
      ..._commandesMock
        .where((c) => _filtreCommande == 'Toutes' ||
            c['statut'] == _filtreCommande)
        .toList()
        .asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _CommandeRow(
            commande: e.value,
            onTap: () => setState(() => _selectedCommande = e.value),
          ).animate(delay: (e.key * 50).ms).fadeIn().slideY(begin: 0.05),
        )),

      // État vide
      if (_commandesMock.where((c) =>
          _filtreCommande == 'Toutes' ||
          c['statut'] == _filtreCommande).isEmpty)
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text('Aucune commande dans cette catégorie',
              style: GoogleFonts.dmSans(
                fontSize: 13, color: AppColors.textLight)),
          ),
        ),
    ]),
  );
  // ─── COMMANDE DETAIL ──────────────────────────────────────────────────────
  Widget _buildCommandeDetail(Map<String, dynamic> c) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: () => setState(() => _selectedCommande = null),
        child: Row(children: [
          const Icon(Icons.arrow_back, size: 16, color: AppColors.textLight),
          const SizedBox(width: 4),
          Text('Retour aux commandes', style: GoogleFonts.dmSans(
            fontSize: 13, color: AppColors.textLight)),
        ]),
      ),
      const SizedBox(height: 24),
      Text('Commande ${c['id']}',
        style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 4),
      StatusBadge(c['statut'], type: c['badgeType']),
      const SizedBox(height: 28),

      // Infos client
      _DetailSection(title: 'Client', children: [
        _DetailRow(label: 'Nom', value: c['client']),
        _DetailRow(label: 'Date', value: c['date']),
        _DetailRow(label: 'Adresse livraison', value: '12 Rue de la Paix, Tunis'),
      ]),
      const SizedBox(height: 16),

      // Lignes commande
      _DetailSection(title: 'Articles commandés', children: [
        _DetailRow(label: 'Monstera Deliciosa × 2', value: '56.00 DT'),
        _DetailRow(label: 'Cactus Saguaro × 1', value: '12.50 DT'),
      ]),
      const SizedBox(height: 16),

      // Total
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceGrey,
          borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: GoogleFonts.dmSans(
              fontSize: 14, color: AppColors.textMedium)),
            Text(c['montant'], style: GoogleFonts.dmSans(
              fontSize: 18, fontWeight: FontWeight.w600,
              color: AppColors.textDark)),
          ],
        ),
      ),

      if (c['statut'] == 'En attente') ...[
        const SizedBox(height: 28),
        Row(children: [
          Expanded(
            child: SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: () => _actionCommande(c, 'Acceptée'),
                child: const Text('Accepter la commande')),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 46,
              child: OutlinedButton(
                onPressed: () => _actionCommande(c, 'Refusée'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                child: Text('Refuser',
                  style: GoogleFonts.dmSans(
                    color: AppColors.error, fontSize: 14,
                    fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ]),
      ],
    ]),
  );

  // ─── PROFIL ───────────────────────────────────────────────────────────────
  Widget _buildProfil() => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Profil', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 32),
      Center(child: Column(children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: AppColors.accent, shape: BoxShape.circle),
          child: Center(child: Text('KB',
            style: GoogleFonts.dmSans(
              color: AppColors.primary, fontSize: 24,
              fontWeight: FontWeight.w600)))),
        const SizedBox(height: 14),
        Text('Karim Belhaj',
          style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(20)),
          child: Text('Vendeur', style: GoogleFonts.dmSans(
            fontSize: 11, color: AppColors.primary,
            fontWeight: FontWeight.w500)),
        ),
      ])),
      const SizedBox(height: 32),
      _ProfilField(label: 'Email', value: 'karim@phytocare.tn'),
      _ProfilField(label: 'Téléphone', value: '+216 55 000 001'),
      _ProfilField(label: 'Spécialité', value: 'Plantes tropicales'),
      _ProfilField(label: 'Références gérées', value: '42 plantes'),
      _ProfilField(label: 'Membre depuis', value: 'Janvier 2025'),
      const SizedBox(height: 24),
      SizedBox(
        width: double.infinity, height: 46,
        child: ElevatedButton(
          onPressed: () => context.go('/profil/modifier?role=VENDEUR'),
          child: const Text('Modifier le profil')),
      ),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: () async {
          await ref.read(authProvider.notifier).logout();
          if (context.mounted) context.go('/login');
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFCEBEB),
            borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text('Se déconnecter',
            style: GoogleFonts.dmSans(
              color: AppColors.error, fontSize: 13,
              fontWeight: FontWeight.w500))),
        ),
      ),
    ]),
  );

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  void _confirmSupprimer(String nom) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Supprimer $nom ?',
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('$nom supprimée',
                  style: GoogleFonts.dmSans(color: Colors.white)),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ));
            },
            child: Text('Supprimer',
              style: GoogleFonts.dmSans(
                color: AppColors.error, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  void _actionCommande(Map<String, dynamic> c, String statut) {
    Navigator.of(context, rootNavigator: false);
    setState(() => _selectedCommande = null);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Commande ${c['id']} — $statut',
        style: GoogleFonts.dmSans(color: Colors.white)),
      backgroundColor: statut == 'Acceptée'
          ? AppColors.success : AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ─── MOCK DATA ────────────────────────────────────────────────────────────
  static final _commandesMock = [
    {'id': '#018', 'client': 'Salma Ahmed', 'date': '10/04/2026',
     'montant': '68.50 DT', 'statut': 'En attente',
     'badgeType': BadgeType.amber},
    {'id': '#017', 'client': 'Youssef Triki', 'date': '09/04/2026',
     'montant': '120.00 DT', 'statut': 'Acceptée',
     'badgeType': BadgeType.green},
    {'id': '#016', 'client': 'Ines Mzali', 'date': '08/04/2026',
     'montant': '35.00 DT', 'statut': 'Acceptée',
     'badgeType': BadgeType.green},
    {'id': '#015', 'client': 'Nadia Ben Ali', 'date': '07/04/2026',
     'montant': '90.00 DT', 'statut': 'Refusée',
     'badgeType': BadgeType.red},
  ];
}

// ─── WIDGETS LOCAUX ───────────────────────────────────────────────────────────

class _CommandeRow extends StatelessWidget {
  final Map<String, dynamic> commande;
  final VoidCallback onTap;
  const _CommandeRow({required this.commande, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(width: 38, height: 38,
          decoration: BoxDecoration(
            color: AppColors.surfaceGrey,
            borderRadius: BorderRadius.circular(8)),
          child: Center(child: Container(
            width: 14, height: 14,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryLight, width: 2),
              borderRadius: BorderRadius.circular(3))))),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Commande ${commande['id']}',
              style: GoogleFonts.dmSans(fontSize: 13,
                  fontWeight: FontWeight.w500, color: AppColors.textDark)),
            Text('${commande['client']} · ${commande['date']}',
              style: GoogleFonts.dmSans(
                  fontSize: 11, color: AppColors.textLight)),
          ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(commande['montant'], style: GoogleFonts.dmSans(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: AppColors.textDark)),
          const SizedBox(height: 4),
          StatusBadge(commande['statut'], type: commande['badgeType']),
        ]),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, color: AppColors.textLight, size: 18),
      ]),
    ),
  );
}

class _ActionCard extends StatelessWidget {
  final String title, subtitle;
  final VoidCallback onTap;
  const _ActionCard({required this.title, required this.subtitle,
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
              color: AppColors.primaryLight, shape: BoxShape.circle)))),
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

class _PlanteRow extends StatelessWidget {
  final String nom, type, badgeLabel;
  final int stock;
  final double prix;
  final BadgeType badge;
  final VoidCallback onModifier;
  final VoidCallback onSupprimer;
  const _PlanteRow({required this.nom, required this.type,
      required this.stock, required this.prix,
      required this.badge, required this.badgeLabel,
      required this.onModifier, required this.onSupprimer});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border)),
    child: Row(children: [
      Container(width: 38, height: 38,
        decoration: BoxDecoration(
          color: AppColors.accentLight,
          borderRadius: BorderRadius.circular(8)),
        child: Center(child: Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
            color: AppColors.primaryLight, shape: BoxShape.circle)))),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nom, style: GoogleFonts.dmSans(
            fontSize: 13, fontWeight: FontWeight.w500,
            color: AppColors.textDark)),
          Text('$type · Stock: $stock · ${prix.toStringAsFixed(2)} DT',
            style: GoogleFonts.dmSans(
              fontSize: 11, color: AppColors.textLight)),
        ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        StatusBadge(badgeLabel, type: badge),
        const SizedBox(height: 6),
        Row(children: [
          _Btn(label: 'Modifier', color: AppColors.primary,
              onTap: onModifier),
          const SizedBox(width: 6),
          _Btn(label: 'Supprimer', color: AppColors.error,
              onTap: onSupprimer),
        ]),
      ]),
    ]),
  );
}

class _Btn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Btn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: GoogleFonts.dmSans(
        fontSize: 10, fontWeight: FontWeight.w500, color: color)),
    ),
  );
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title.toUpperCase(), style: GoogleFonts.dmSans(
        fontSize: 11, fontWeight: FontWeight.w500,
        color: AppColors.textLight, letterSpacing: 0.06)),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border)),
        child: Column(children: children),
      ),
    ],
  );
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.border))),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.dmSans(
        fontSize: 12, color: AppColors.textLight)),
      Text(value, style: GoogleFonts.dmSans(
        fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark)),
    ]),
  );
}

class _ProfilField extends StatelessWidget {
  final String label, value;
  const _ProfilField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: AppColors.surfaceGrey,
      borderRadius: BorderRadius.circular(10)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.dmSans(
        fontSize: 12, color: AppColors.textLight)),
      Text(value, style: GoogleFonts.dmSans(
        fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark)),
    ]),
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