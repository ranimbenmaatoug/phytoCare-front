import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class EditPlanteScreen extends StatefulWidget {
  final int planteId;
  const EditPlanteScreen({super.key, required this.planteId});

  @override
  State<EditPlanteScreen> createState() => _EditPlanteScreenState();
}

class _EditPlanteScreenState extends State<EditPlanteScreen> {
  late final TextEditingController _nom;
  late final TextEditingController _type;
  late final TextEditingController _desc;
  late final TextEditingController _prix;
  late final TextEditingController _stock;
  late final TextEditingController _eau;
  late final TextEditingController _temp;
  late final TextEditingController _saison;
  bool _loading = false;
  int _activeTab = 0; // 0 = infos, 1 = stock

  // Données mockées — à remplacer par appel API GET /plantes/:id
  final _mockData = {
    'nom': 'Cactus Saguaro',
    'type': 'Cactus',
    'desc': 'Un cactus emblématique du désert de Sonora.',
    'prix': '12.50',
    'stock': '12',
    'eau': 'Faible',
    'temp': '20-35°C',
    'saison': 'Printemps',
  };

  @override
  void initState() {
    super.initState();
    _nom    = TextEditingController(text: _mockData['nom']);
    _type   = TextEditingController(text: _mockData['type']);
    _desc   = TextEditingController(text: _mockData['desc']);
    _prix   = TextEditingController(text: _mockData['prix']);
    _stock  = TextEditingController(text: _mockData['stock']);
    _eau    = TextEditingController(text: _mockData['eau']);
    _temp   = TextEditingController(text: _mockData['temp']);
    _saison = TextEditingController(text: _mockData['saison']);
  }

  @override
  void dispose() {
    _nom.dispose(); _type.dispose(); _desc.dispose();
    _prix.dispose(); _stock.dispose(); _eau.dispose();
    _temp.dispose(); _saison.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.go('/vendeur'),
          child: const Icon(Icons.arrow_back,
              color: AppColors.textDark, size: 20)),
        title: Text('Modifier la plante',
          style: GoogleFonts.dmSans(
            fontSize: 16, fontWeight: FontWeight.w600,
            color: AppColors.textDark)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              // Tabs
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Row(children: [
                  _Tab(label: 'Informations',
                      active: _activeTab == 0,
                      onTap: () => setState(() => _activeTab = 0)),
                  const SizedBox(width: 8),
                  _Tab(label: 'Modifier le stock',
                      active: _activeTab == 1,
                      onTap: () => setState(() => _activeTab = 1)),
                ]),
              ),
              const SizedBox(height: 4),
              const Divider(color: AppColors.border, height: 1),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _activeTab == 0
                      ? _buildInfosForm()
                      : _buildStockForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── FORMULAIRE INFOS ─────────────────────────────────────────────────────
  Widget _buildInfosForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _section('Informations générales'),
      const SizedBox(height: 14),
      _field(_nom, 'Nom scientifique', 'Ex: Monstera Deliciosa'),
      const SizedBox(height: 12),
      _field(_type, 'Type de plante', 'Ex: Tropicale, Cactus'),
      const SizedBox(height: 12),
      _textarea(_desc, 'Description'),
      const SizedBox(height: 24),

      _section('Prix'),
      const SizedBox(height: 14),
      _field(_prix, 'Prix (DT)', '0.00', type: TextInputType.number),
      const SizedBox(height: 24),

      _section('Conditions de culture'),
      const SizedBox(height: 14),
      _field(_eau, 'Besoin en eau', 'Ex: Faible, Modéré, Élevé'),
      const SizedBox(height: 12),
      _field(_temp, 'Température optimale', 'Ex: 18-25°C'),
      const SizedBox(height: 12),
      _field(_saison, 'Saison de plantation', 'Ex: Printemps'),
      const SizedBox(height: 24),

      _section('Photo'),
      const SizedBox(height: 14),
      GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity, height: 100,
          decoration: BoxDecoration(
            color: AppColors.surfaceGrey,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 32, height: 32,
                decoration: BoxDecoration(
                  color: AppColors.accentLight, shape: BoxShape.circle),
                child: Center(child: Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.primaryLight, width: 2),
                    shape: BoxShape.circle)))),
              const SizedBox(height: 8),
              Text('Changer la photo', style: GoogleFonts.dmSans(
                fontSize: 12, color: AppColors.textLight)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 32),

      SizedBox(
        width: double.infinity, height: 48,
        child: ElevatedButton(
          onPressed: _loading ? null : _submitInfos,
          child: _loading
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Text('Enregistrer les modifications'),
        ),
      ).animate().fadeIn(),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity, height: 48,
        child: OutlinedButton(
          onPressed: () => context.go('/vendeur'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
          child: Text('Annuler', style: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w500,
            color: AppColors.textMedium)),
        ),
      ),
    ],
  );

  // ─── FORMULAIRE STOCK ─────────────────────────────────────────────────────
  Widget _buildStockForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _section('Stock actuel'),
      const SizedBox(height: 14),

      // Info stock actuel
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.accentLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quantité actuelle en stock',
              style: GoogleFonts.dmSans(
                fontSize: 13, color: AppColors.textMedium)),
            Text(_stock.text,
              style: GoogleFonts.dmSans(
                fontSize: 22, fontWeight: FontWeight.w600,
                color: AppColors.primary)),
          ],
        ),
      ),
      const SizedBox(height: 24),

      _section('Nouvelle quantité'),
      const SizedBox(height: 14),
      Text('Quantité en stock', style: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: AppColors.textMedium)),
      const SizedBox(height: 6),
      TextField(
        controller: _stock,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Entrez la nouvelle quantité'),
      ),
      const SizedBox(height: 8),
      Text(
        'La valeur doit être un nombre entier positif.',
        style: GoogleFonts.dmSans(
            fontSize: 11, color: AppColors.textLight)),
      const SizedBox(height: 32),

      SizedBox(
        width: double.infinity, height: 48,
        child: ElevatedButton(
          onPressed: _loading ? null : _submitStock,
          child: _loading
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Text('Mettre à jour le stock'),
        ),
      ).animate().fadeIn(),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity, height: 48,
        child: OutlinedButton(
          onPressed: () => context.go('/vendeur'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
          child: Text('Annuler', style: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w500,
            color: AppColors.textMedium)),
        ),
      ),
    ],
  );

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  Widget _section(String t) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(t.toUpperCase(), style: GoogleFonts.dmSans(
        fontSize: 11, fontWeight: FontWeight.w500,
        color: AppColors.textLight, letterSpacing: 0.06)),
      const SizedBox(height: 8),
      const Divider(color: AppColors.border),
    ],
  );

  Widget _field(TextEditingController c, String label,
      String hint, {TextInputType? type}) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: AppColors.textMedium)),
      const SizedBox(height: 6),
      TextField(controller: c, keyboardType: type,
        decoration: InputDecoration(hintText: hint)),
    ]);

  Widget _textarea(TextEditingController c, String label) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: AppColors.textMedium)),
      const SizedBox(height: 6),
      TextField(controller: c, maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Description de la plante...')),
    ]);

  Future<void> _submitInfos() async {
    setState(() => _loading = true);
    // TODO: PUT /api/plantes/${widget.planteId}
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Plante modifiée avec succès',
        style: GoogleFonts.dmSans(color: Colors.white)),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
    context.go('/vendeur');
  }

  Future<void> _submitStock() async {
    final val = int.tryParse(_stock.text);
    if (val == null || val < 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Quantité invalide — entrez un nombre entier positif',
          style: GoogleFonts.dmSans(color: Colors.white)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }
    setState(() => _loading = true);
    // TODO: PATCH /api/plantes/${widget.planteId}/stock
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Stock mis à jour : $val unités',
        style: GoogleFonts.dmSans(color: Colors.white)),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
    context.go('/vendeur');
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: active ? AppColors.primary : AppColors.border)),
      child: Text(label, style: GoogleFonts.dmSans(
        fontSize: 13, fontWeight: FontWeight.w500,
        color: active ? Colors.white : AppColors.textMedium)),
    ),
  );
}