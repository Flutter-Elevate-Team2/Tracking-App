import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/widgets/profile_settings_tile.dart';
import 'package:tracking_app/Features/profile/presentation/widgets/profile_user_card.dart';
import 'package:tracking_app/Features/profile/presentation/widgets/profile_vehicle_card.dart';
import 'package:tracking_app/Features/profile/presentation/widgets/profile_version_footer.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProfileViewModel>()..doIntent(GetDriverProfileEvent()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(AppLocalizations.of(context)?.profile ?? 'Profile'),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined, size: 28),
                  onPressed: () {
                    // Navigate to notifications
                  },
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.red,
                    ),
                    child: Text(
                      '3',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: BlocListener<ProfileViewModel, ProfileStates>(
          listenWhen: (previous, current) =>
              previous.logoutState != current.logoutState,
          listener: (context, state) {
            if (state.logoutState?.isLoading == true) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
            } else {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }

              if (state.logoutState?.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.logoutState!.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: BlocBuilder<ProfileViewModel, ProfileStates>(
            buildWhen: (previous, current) =>
                previous.profileState != current.profileState,
            builder: (context, state) {
              final profileState = state.profileState;

              if (profileState?.isLoading == true) {
                return _buildShimmerLoading();
              }

              if (profileState?.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profileState!.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<ProfileViewModel>()
                              .doIntent(GetDriverProfileEvent());
                        },
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                );
              }

              if (profileState?.data != null) {
                final driver = profileState!.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileUserCard(
                        driver: driver,
                        onTap: () {
                          context.pushNamed(Routes.editProfileName);
                        },
                      ),

                      ProfileVehicleCard(
                        driver: driver,
                        onTap: () {
                          context.pushNamed(Routes.editVehicleName);
                        },
                      ),

                      const SizedBox(height: 16),

                      ProfileSettingsTile(
                        icon: Icons.translate,
                        title: AppLocalizations.of(context)?.language ?? 'Language',
                        trailing: Text(
                          'English',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.mainColor,
                              ),
                        ),
                        onTap: () {
                          _showLanguageDialog(context);
                        },
                      ),

                      Builder(builder: (innerContext) {
                        return ProfileSettingsTile(
                          icon: Icons.logout,
                          title: AppLocalizations.of(context)?.logout ?? 'Logout',
                          iconColor: AppColors.red,
                          titleColor: AppColors.red,
                          trailing: const Icon(Icons.exit_to_app,
                              color: AppColors.red, size: 20),
                          onTap: () {
                            _showLogoutDialog(innerContext);
                          },
                        );
                      }),

                      const SizedBox(height: 24),
                      const ProfileVersionFooter(),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: const [
          AppShimmer(height: 100, radius: 12),
          SizedBox(height: 16),
          AppShimmer(height: 100, radius: 12),
          SizedBox(height: 16),
          AppShimmer(height: 60, radius: 8),
          SizedBox(height: 16),
          AppShimmer(height: 60, radius: 8),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Arabic'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.logoutTitle ?? 'LOGOUT'),
        content: Text(
          AppLocalizations.of(context)?.confirmLogout ?? 'Confirm logout!!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)?.cancelDialog ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ProfileViewModel>().doIntent(LogoutEvent());
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(AppLocalizations.of(context)?.logout ?? 'Logout'),
          ),
        ],
      ),
    );
  }
}
