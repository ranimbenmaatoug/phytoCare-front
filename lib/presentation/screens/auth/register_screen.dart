import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nomCtrl     = TextEditingController();
  final _prenomCtrl  = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _passCtrl    = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(children: [
        if (isWide)
          Expanded(
            child: Container(
              color: AppColors.sidebarBg,
              padding: const EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8))),
                  const Spacer(),
                  Text('Rejoignez\nPhytoCare',
                    style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 36,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5, height: 1.2)),
                  const SizedBox(height: 12),
                  Text('Créez votre compte et découvrez\nnotre catalogue de plantes.',
                    style: GoogleFonts.dmSans(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 15, height: 1.6)),
                  const Spacer(),
                ],
              ),
            ),
          ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 56 : 28,
                vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isWide) ...[
                      Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8))),
                      const SizedBox(height: 24),
                    ],
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Row(children: [
                        const Icon(Icons.arrow_back,
                          size: 16, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Text('Retour', style: GoogleFonts.dmSans(
                          fontSize: 13, color: AppColors.textLight)),
                      ]),
                    ),
                    const SizedBox(height: 24),
                    Text('Créer un compte',
                      style: GoogleFonts.dmSans(
                        fontSize: 24, fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                        letterSpacing: -0.3)),
                    const SizedBox(height: 6),
                    Text('Remplissez les informations ci-dessous',
                      style: GoogleFonts.dmSans(
                        fontSize: 13, color: AppColors.textLight)),
                    const SizedBox(height: 28),

                    Row(children: [
                      Expanded(child: _field(_nomCtrl, 'Nom', 'Dupont')),
                      const SizedBox(width: 12),
                      Expanded(child: _field(_prenomCtrl, 'Prénom', 'Jean')),
                    ]),
                    const SizedBox(height: 14),
                    _field(_emailCtrl, 'Email', 'nom@email.com',
                        type: TextInputType.emailAddress),
                    const SizedBox(height: 14),
                    _field(_phoneCtrl, 'Téléphone', '+216 55 000 000',
                        type: TextInputType.phone),
                    const SizedBox(height: 14),
                    _field(_adresseCtrl, 'Adresse', 'Tunis, Tunisie'),
                    const SizedBox(height: 14),

                    Text('Mot de passe', style: GoogleFonts.dmSans(
                      fontSize: 12, fontWeight: FontWeight.w500,
                      color: AppColors.textMedium)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscure = !_obscure),
                          child: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textLight, size: 18)),
                      ),
                    ),
                    const SizedBox(height: 28),

                    if (auth.error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCEBEB),
                          borderRadius: BorderRadius.circular(8)),
                        child: Text(auth.error!,
                          style: GoogleFonts.dmSans(
                            color: AppColors.error, fontSize: 13)),
                      ),

                    SizedBox(
                      width: double.infinity, height: 48,
                      child: ElevatedButton(
                        onPressed: auth.isLoading ? null : () async {
                          final user = UserModel(
                            nom: _nomCtrl.text,
                            prenom: _prenomCtrl.text,
                            email: _emailCtrl.text,
                            motDePasse: _passCtrl.text,
                            numeroTelephone: _phoneCtrl.text,
                            adresse: _adresseCtrl.text,
                            role: 'CLIENT',
                          );
                          final ok = await ref
                              .read(authProvider.notifier)
                              .register(user);
                          if (!mounted) return;
                          if (ok) context.go('/login');
                        },
                        child: auth.isLoading
                            ? const SizedBox(width: 18, height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                            : const Text('Créer mon compte'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go('/login'),
                        child: RichText(text: TextSpan(
                          text: 'Déjà un compte ? ',
                          style: GoogleFonts.dmSans(
                            color: AppColors.textLight, fontSize: 13),
                          children: [TextSpan(
                            text: 'Se connecter',
                            style: GoogleFonts.dmSans(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 13))],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      String hint, {TextInputType? type}) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: AppColors.textMedium)),
      const SizedBox(height: 6),
      TextField(controller: ctrl, keyboardType: type,
        decoration: InputDecoration(hintText: hint)),
    ]);
}