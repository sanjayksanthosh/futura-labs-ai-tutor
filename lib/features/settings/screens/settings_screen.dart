import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/page_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<AuthProvider>().user;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.surfaceDark, AppColors.backgroundDark]
              : [const Color(0xFFF0F0FF), const Color(0xFFF8F9FE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(title: 'Profile'),
                const SizedBox(height: 16),
              _buildProfileCard(context, user),
              const SizedBox(height: 24),
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingsItem(
                context,
                Icons.color_lens_outlined,
                'Theme',
                isDark ? 'Dark' : 'Light',
                () {
                  context.read<ThemeProvider>().toggleTheme();
                },
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) {
                    context.read<ThemeProvider>().toggleTheme();
                  },
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                  activeThumbColor: AppColors.primary,
                ),
              ),
              _buildSettingsItem(
                context,
                Icons.notifications_outlined,
                'Notifications',
                '',
                () {},
                trailing: Switch(
                  value: true,
                  onChanged: (_) {},
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                  activeThumbColor: AppColors.primary,
                ),
              ),
              _buildSettingsItem(
                context,
                Icons.download_outlined,
                'Downloaded Lessons',
                '3 lessons',
                () {},
              ),
              _buildSettingsItem(
                context,
                Icons.edit_outlined,
                'Edit Profile',
                '',
                () {},
              ),
              _buildSettingsItem(
                context,
                Icons.lock_outline,
                'Change Password',
                '',
                () {},
              ),
              _buildSettingsItem(
                context,
                Icons.admin_panel_settings,
                'Admin Panel',
                '',
                () => context.push('/admin'),
              ),
              _buildSettingsItem(
                context,
                Icons.info_outline,
                'About',
                'v1.0.0',
                () {},
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Logout'),
                        content:
                            const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Logout',
                                style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && context.mounted) {
                      await context.read<AuthProvider>().logout();
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, dynamic user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: user?.avatar != null
                ? NetworkImage(user!.avatar!)
                : null,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: user?.avatar == null
                ? Text(
                    user?.name.isNotEmpty == true
                        ? user!.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Learner',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : AppColors.textSecondary,
                  ),
                ),
                if (user?.institution != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    user!.institution!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : AppColors.textSecondary,
                ),
              )
            : null,
        trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textLight),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isDark ? AppColors.cardDark : Colors.white,
      ),
    );
  }
}
