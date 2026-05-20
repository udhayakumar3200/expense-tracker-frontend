import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/supabase_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.find<AuthController>().logout(),
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.find<SupabaseService>().currentUser;
    final email = user?.email ?? '';
    final name = (user?.userMetadata?['name'] as String?)?.trim() ?? '';
    final displayName = name.isNotEmpty ? name : email;
    final avatarLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      avatarLetter,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  AppSpacing.verticalMd,
                  if (name.isNotEmpty)
                    Text(name, style: AppTextStyles.h4),
                  AppSpacing.verticalXs,
                  Text(email, style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Text('ACCOUNT', style: AppTextStyles.labelSmall),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            subtitle: Text(email),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Text('APP', style: AppTextStyles.labelSmall),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            trailing: Text('1.0.0'),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error),
            title: Text(
              'Logout',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
            onTap: _showLogoutDialog,
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
