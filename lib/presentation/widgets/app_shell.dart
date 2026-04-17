import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class NavItem {
  final String label;
  final String route;
  const NavItem({required this.label, required this.route});
}

class AppShell extends ConsumerWidget {
  final List<NavItem> navItems;
  final String currentRoute;
  final String userName;
  final String userRole;
  final Widget body;

  const AppShell({
    super.key,
    required this.navItems,
    required this.currentRoute,
    required this.userName,
    required this.userRole,
    required this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.of(context).size.width > 700;

    Future<void> logout() async {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) context.go('/login');
    }

    final sidebarContent = _SidebarContent(
      navItems: navItems,
      currentRoute: currentRoute,
      userName: userName,
      userRole: userRole,
      onLogout: logout,
      onNavTap: (route) {
        if (!isWide) Navigator.of(context).pop();
        context.go(route);
      },
    );

    if (isWide) {
      return Scaffold(
        body: Row(children: [
          SizedBox(width: 220, child: sidebarContent),
          Expanded(child: body),
        ]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.sidebarBg,
        elevation: 0,
        leading: Builder(builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 20),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        )),
        title: Text('PhytoCare', style: GoogleFonts.dmSans(
          color: Colors.white, fontSize: 16,
          fontWeight: FontWeight.w600)),
      ),
      drawer: Drawer(
        width: 220,
        backgroundColor: AppColors.sidebarBg,
        child: sidebarContent,
      ),
      body: body,
    );
  }
}

class _SidebarContent extends StatelessWidget {
  final List<NavItem> navItems;
  final String currentRoute;
  final String userName;
  final String userRole;
  final VoidCallback onLogout;
  final void Function(String route) onNavTap;

  const _SidebarContent({
    required this.navItems,
    required this.currentRoute,
    required this.userName,
    required this.userRole,
    required this.onLogout,
    required this.onNavTap,
  });

  String get _subtitle {
    if (userRole == 'Vendeur') return 'Espace vendeur';
    if (userRole == 'Administrateur') return 'Administration';
    return 'Pépinière en ligne';
  }

  String get _initials {
    final parts = userName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return userName.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sidebarBg,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8)),
            ),
            const SizedBox(height: 10),
            Text('PhytoCare', style: GoogleFonts.dmSans(
              color: Colors.white, fontSize: 16,
              fontWeight: FontWeight.w600)),
            Text(_subtitle, style: GoogleFonts.dmSans(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 11)),
          ]),
        ),
        const Divider(color: Colors.white12, height: 1),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: navItems.map((item) {
              final isActive = currentRoute == item.route;
              return GestureDetector(
                onTap: () => onNavTap(item.route),
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
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? AppColors.primaryLight
                            : Colors.white.withValues(alpha: 0.2)),
                    ),
                    const SizedBox(width: 12),
                    Text(item.label, style: GoogleFonts.dmSans(
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
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle),
              child: Center(child: Text(_initials,
                style: GoogleFonts.dmSans(
                  color: Colors.white, fontSize: 12,
                  fontWeight: FontWeight.w600))),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: GoogleFonts.dmSans(
                  color: Colors.white, fontSize: 13,
                  fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis),
                Text(userRole, style: GoogleFonts.dmSans(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 11)),
              ],
            )),
            GestureDetector(
              onTap: onLogout,
              child: Icon(Icons.logout_rounded,
                color: Colors.white.withValues(alpha: 0.4), size: 18)),
          ]),
        ),
      ]),
    );
  }
}