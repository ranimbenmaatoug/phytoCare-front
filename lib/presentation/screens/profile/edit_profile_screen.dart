import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  final String role;
  const EditProfileScreen({super.key, required this.role});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nom;
  late final TextEditingController _prenom;
  late final TextEditingController _email;
  late final TextEditingController _tel;
  late final TextEditingController _adresse;
  late final TextEditingController _passActuel;
  late final TextEditingController _passNouveau;
  late final TextEditingController _passConfirm;
  bool _loading = false;
  bool _obscureActuel = true;
  bool _obscureNouveau = true;
  bool _obscureConfirm = true;
  int _activeTab = 0; // 0 = infos, 1 = mot de passe

  // Mock — remplacer par données réelles depuis authProvider
  Map<String, String> get _mockData {
    if (widget.role == 'VENDEUR') {
      return {'nom': 'Belhaj', 'prenom': 'Karim',
               'email': 'karim@phytocare.tn', 'tel': '+216 55 000 001',
               'adresse': 'Sfax, Tunisie'};
    }
    if (widget.role == 'ADMINISTRATEUR') {
      return {'nom': 'Admin', 'prenom': '',
               'email': 'admin@phytocare.tn', 'tel': '',
               'adresse': ''};
    }
    return {'nom': 'Ahmed', 'prenom': 'Salma',
             'email': 'salma@email.com', 'tel': '+216 55 123 456',
             'adresse': 'Tunis, Tunisie'};
  }

  @override
  void initState() {
    super.initState();
    final d = _mockData;
    _nom        = TextEditingController(text: d['nom']);
    _prenom     = TextEditingController(text: d['prenom']);
    _email      = TextEditingController(text: d['email']);
    _tel        = TextEditingController(text: d['tel']);
    _adresse    = TextEditingController(text: d['adresse']);
    _passActuel = TextEditingController();
    _passNouveau= TextEditingController();
    _passConfirm= TextEditingController();
  }

  @override
  void dispose() {
    _nom.dispose(); _prenom.dispose(); _email.dispose();
    _tel.dispose(); _adresse.dispose();
    _passActuel.dispose(); _passNouveau.dispose(); _passConfirm.dispose();
    super.dispose();
  }

  String get _backRoute {
    if (widget.role == 'VENDEUR') return '/vendeur';
    if (widget.role == 'ADMINISTRATEUR') return '/admin';
    return '/home';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.go(_backRoute),
          child: const Icon(Icons.arrow_back,
              color: AppColors.textDark, size: 20)),
        title: Text('Modifier le profil',
          style: GoogleFonts.dmSans(
            fontSize: 16, fontWeight: FontWeight.w600,
            color: AppColors.textDark)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(children: [
            // Tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Row(children: [
                _Tab(label: 'Informations personnelles',
                    active: _activeTab == 0,
                    onTap: () => setState(() => _activeTab = 0)),
                const SizedBox(width: 8),
                _Tab(label: 'Mot de passe',
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
                    : _buildPasswordForm(),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ─── INFOS ────────────────────────────────────────────────────────────────
  Widget _buildInfosForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Avatar
      Center(child: Stack(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppColors.accentLight, shape: BoxShape.circle),
            child: Center(child: Text(
              '${_prenom.text.isNotEmpty ? _prenom.text[0] : ''}${_nom.text.isNotEmpty ? _nom.text[0] : ''}'.toUpperCase(),
              style: GoogleFonts.dmSans(
                color: AppColors.primary, fontSize: 26,
                fontWeight: FontWeight.w600))),
          ),
          Positioned(
            right: 0, bottom: 0,
            child: Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.edit, color: Colors.white, size: 14)),
          ),
        ],
      )),
      const SizedBox(height: 28),

      _section('Informations personnelles'),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: _field(_prenom, 'Prénom', 'Jean')),
        const SizedBox(width: 12),
        Expanded(child: _field(_nom, 'Nom', 'Dupont')),
      ]),
      const SizedBox(height: 12),
      _field(_email, 'Email', 'nom@email.com',
          type: TextInputType.emailAddress),
      const SizedBox(height: 12),
      _field(_tel, 'Téléphone', '+216 55 000 000',
          type: TextInputType.phone),
      if (widget.role == 'CLIENT') ...[
        const SizedBox(height: 12),
        _field(_adresse, 'Adresse', 'Tunis, Tunisie'),
      ],
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
          onPressed: () => context.go(_backRoute),
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

  // ─── MOT DE PASSE ─────────────────────────────────────────────────────────
  Widget _buildPasswordForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _section('Changer le mot de passe'),
      const SizedBox(height: 14),

      _passField(_passActuel, 'Mot de passe actuel',
          _obscureActuel, () => setState(() => _obscureActuel = !_obscureActuel)),
      const SizedBox(height: 12),
      _passField(_passNouveau, 'Nouveau mot de passe',
          _obscureNouveau, () => setState(() => _obscureNouveau = !_obscureNouveau)),
      const SizedBox(height: 12),
      _passField(_passConfirm, 'Confirmer le nouveau mot de passe',
          _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
      const SizedBox(height: 8),
      Text('Le mot de passe doit contenir au moins 8 caractères.',
        style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textLight)),
      const SizedBox(height: 32),

      SizedBox(
        width: double.infinity, height: 48,
        child: ElevatedButton(
          onPressed: _loading ? null : _submitPassword,
          child: _loading
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Text('Changer le mot de passe'),
        ),
      ).animate().fadeIn(),
      const SizedBox(height: 10),
      SizedBox(
        width: double.infinity, height: 48,
        child: OutlinedButton(
          onPressed: () => context.go(_backRoute),
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

  Widget _passField(TextEditingController c, String label,
      bool obscure, VoidCallback toggle) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: AppColors.textMedium)),
      const SizedBox(height: 6),
      TextField(
        controller: c, obscureText: obscure,
        decoration: InputDecoration(
          hintText: '••••••••',
          suffixIcon: GestureDetector(
            onTap: toggle,
            child: Icon(
              obscure ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              color: AppColors.textLight, size: 18))),
      ),
    ]);

  Future<void> _submitInfos() async {
    setState(() => _loading = true);
    // TODO: PUT /api/utilisateurs/profil
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Profil mis à jour avec succès',
        style: GoogleFonts.dmSans(color: Colors.white)),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
    context.go(_backRoute);
  }

  Future<void> _submitPassword() async {
    if (_passNouveau.text != _passConfirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Les mots de passe ne correspondent pas',
          style: GoogleFonts.dmSans(color: Colors.white)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }
    if (_passNouveau.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Le mot de passe doit contenir au moins 8 caractères',
          style: GoogleFonts.dmSans(color: Colors.white)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }
    setState(() => _loading = true);
    // TODO: PUT /api/utilisateurs/password
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Mot de passe modifié avec succès',
        style: GoogleFonts.dmSans(color: Colors.white)),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
    context.go(_backRoute);
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: active ? AppColors.primary : AppColors.border)),
      child: Text(label, style: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: active ? Colors.white : AppColors.textMedium)),
    ),
  );
}