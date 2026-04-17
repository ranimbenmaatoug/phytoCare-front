import 'package:go_router/go_router.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/plantes/plantes_screen.dart';
import '../../presentation/screens/plantes/plante_detail_screen.dart';
import '../../presentation/screens/panier/panier_screen.dart';
import '../../presentation/screens/commandes/commandes_screen.dart';
import '../../presentation/screens/diagnostic/diagnostic_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/vendeur/vendeur_screen.dart';
import '../../presentation/screens/vendeur/add_plante_screen.dart';
import '../../presentation/screens/vendeur/edit_plante_screen.dart';
import '../../presentation/screens/admin/admin_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/',          redirect: (_, __) => '/login'),
    GoRoute(path: '/login',     builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register',  builder: (_, __) => const RegisterScreen()),

    // Client
    GoRoute(path: '/home',       builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/plantes',    builder: (_, __) => const PlantesScreen()),
    GoRoute(
      path: '/plantes/:id',
      builder: (_, state) => PlanteDetailScreen(
          planteId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(path: '/panier',     builder: (_, __) => const PanierScreen()),
    GoRoute(path: '/commandes',  builder: (_, __) => const CommandesScreen()),
    GoRoute(path: '/diagnostic', builder: (_, __) => const DiagnosticScreen()),
    GoRoute(
      path: '/profil/modifier',
      builder: (_, state) => EditProfileScreen(
          role: state.uri.queryParameters['role'] ?? 'CLIENT'),
    ),

    // Vendeur
    GoRoute(path: '/vendeur',           builder: (_, __) => const VendeurScreen()),
    GoRoute(path: '/vendeur/ajouter',   builder: (_, __) => const AddPlanteScreen()),
    GoRoute(
      path: '/vendeur/modifier/:id',
      builder: (_, state) => EditPlanteScreen(
          planteId: int.parse(state.pathParameters['id']!)),
    ),

    // Admin
    GoRoute(path: '/admin', builder: (_, __) => const AdminScreen()),
  ],
);