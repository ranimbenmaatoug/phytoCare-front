import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class AddPlanteScreen extends StatefulWidget {
  const AddPlanteScreen({super.key});
  @override
  State<AddPlanteScreen> createState() => _AddPlanteScreenState();
}

class _AddPlanteScreenState extends State<AddPlanteScreen> {
  final _nom    = TextEditingController();
  final _type   = TextEditingController();
  final _desc   = TextEditingController();
  final _prix   = TextEditingController();
  final _stock  = TextEditingController();
  final _eau    = TextEditingController();
  final _temp   = TextEditingController();
  final _saison = TextEditingController();
  bool _loading = false;

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
        title: Text('Ajouter une plante',
          style: GoogleFonts.dmSans(
            fontSize: 16, fontWeight: FontWeight.w600,
            color: AppColors.textDark)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
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

                _section('Prix & Stock'),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: _field(_prix, 'Prix (DT)', '0.00',
                      type: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: _field(_stock, 'Stock', '0',
                      type: TextInputType.number)),
                ]),
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
                    width: double.infinity, height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGrey,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            shape: BoxShape.circle),
                          child: Center(child: Container(
                            width: 14, height: 14,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.primaryLight, width: 2),
                              shape: BoxShape.circle)))),
                        const SizedBox(height: 10),
                        Text('Choisir une photo',
                          style: GoogleFonts.dmSans(
                            fontSize: 13, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity, height: 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(width: 18, height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                        : const Text('Enregistrer la plante'),
                  ),
                ).animate().fadeIn(),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, height: 48,
                  child: OutlinedButton(
                    onPressed: () => context.go('/vendeur'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    child: Text('Annuler',
                      style: GoogleFonts.dmSans(
                        fontSize: 14, fontWeight: FontWeight.w500,
                        color: AppColors.textMedium)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (mounted) context.go('/vendeur');
  }
}