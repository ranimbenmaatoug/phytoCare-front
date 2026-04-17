import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
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
                  Text('PhytoCare',
                    style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 36,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5)),
                  const SizedBox(height: 12),
                  Text('Votre pépinière en ligne.\nDes plantes pour chaque espace.',
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
                      const SizedBox(height: 32),
                    ],
                    Text('Connexion',
                      style: GoogleFonts.dmSans(
                        fontSize: 24, fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                        letterSpacing: -0.3),
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 6),
                    Text('Accédez à votre espace PhytoCare',
                      style: GoogleFonts.dmSans(
                        fontSize: 13, color: AppColors.textLight),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 36),

                    _Label('Email'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'nom@email.com'),
                    ).animate().fadeIn(delay: 150.ms),
                    const SizedBox(height: 16),

                    _Label('Mot de passe'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordCtrl,
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
                    ).animate().fadeIn(delay: 200.ms),
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
                          final role = await ref
                              .read(authProvider.notifier)
                              .login(_emailCtrl.text, _passwordCtrl.text);
                          if (!mounted) return;
                          if (role == null) return;
                          switch (role) {
                            case 'ADMINISTRATEUR':
                              context.go('/admin'); break;
                            case 'VENDEUR':
                              context.go('/vendeur'); break;
                            default:
                              context.go('/home');
                          }
                        },
                        child: auth.isLoading
                            ? const SizedBox(width: 18, height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                            : const Text('Se connecter'),
                      ),
                    ).animate().fadeIn(delay: 250.ms),
                    const SizedBox(height: 20),

                    Center(
                      child: GestureDetector(
                        onTap: () => context.go('/register'),
                        child: RichText(text: TextSpan(
                          text: 'Pas encore de compte ? ',
                          style: GoogleFonts.dmSans(
                            color: AppColors.textLight, fontSize: 13),
                          children: [TextSpan(
                            text: 'Créer un compte',
                            style: GoogleFonts.dmSans(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 13))],
                        )),
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: GoogleFonts.dmSans(
      fontSize: 12, fontWeight: FontWeight.w500,
      color: AppColors.textMedium));
}