import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class SidebarItem {
  final String label;
  final String route;
  const SidebarItem({required this.label, required this.route});
}

class AppSidebar extends ConsumerWidget {
  final List<SidebarItem> items;
  final String currentRoute;
  final String userName;
  final String userRole;

  const AppSidebar({
    super.key,
    required this.items,
    required this.currentRoute,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 220,
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 10),
                Text('PhytoCare',
                  style: GoogleFonts.dmSans(
                    color: Colors.white, fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  )),
                Text('Pépinière en ligne',
                  style: GoogleFonts.dmSans(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                  )),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 12),

          // Nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: items.map((item) {
                final isActive = currentRoute == item.route;
                return _NavItem(
                  label: item.label,
                  isActive: isActive,
                  onTap: () => context.go(item.route),
                );
              }).toList(),
            ),
          ),

          // User footer
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _Avatar(name: userName),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName,
                        style: GoogleFonts.dmSans(
                          color: Colors.white, fontSize: 13,
                          fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis),
                      Text(userRole,
                        style: GoogleFonts.dmSans(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 11)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                  child: Icon(Icons.logout_rounded,
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryLight.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 6, height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.primaryLight
                    : Colors.white.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(width: 12),
            Text(label,
              style: GoogleFonts.dmSans(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
                fontWeight: isActive
                    ? FontWeight.w500
                    : FontWeight.w400,
              )),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) => Container(
    width: 32, height: 32,
    decoration: BoxDecoration(
      color: AppColors.primaryLight,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(initials,
        style: GoogleFonts.dmSans(
          color: Colors.white, fontSize: 12,
          fontWeight: FontWeight.w600)),
    ),
  );
}