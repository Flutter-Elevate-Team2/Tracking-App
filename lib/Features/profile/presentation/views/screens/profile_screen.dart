import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/language_change_dialog.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/logout_dialog.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_settings_tile.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_shimmer_loading.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_user_card.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_vehicle_card.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_version_footer.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/l10n/view_model/language_cubit.dart';
import 'package:tracking_app/gen/assets.gen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: Assets.images.arrowBackLeft.image(width: 24, height: 24),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          context.l10n.profile,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: const [_NotificationAction()],
      ),
      body: BlocListener<ProfileViewModel, ProfileStates>(
        listenWhen: (previous, current) =>
            previous.logoutState != current.logoutState,
        listener: _handleLogoutState,
        child: BlocBuilder<ProfileViewModel, ProfileStates>(
          buildWhen: (previous, current) =>
              previous.profileState != current.profileState,
          builder: (context, state) {
            final profileState = state.profileState;

            if (profileState?.isLoading == true) {
              return const ProfileShimmerLoading();
            }

            if (profileState?.errorMessage != null) {
              return _ErrorStateWidget(
                errorMessage: profileState!.errorMessage!,
                onRetry: () {
                  context.read<ProfileViewModel>().doIntent(
                    GetDriverProfileEvent(),
                  );
                },
              );
            }

            if (profileState?.data != null) {
              final driver = profileState!.data!;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                      title: context.l10n.language,
                      trailing: BlocBuilder<LanguageCubit, Locale>(
                        builder: (context, locale) {
                          return Text(
                            locale.languageCode == 'ar'
                                ? context.l10n.arabic
                                : context.l10n.english,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.mainColor),
                          );
                        },
                      ),
                      onTap: () => _showLanguageDialog(context),
                    ),
                    ProfileSettingsTile(
                      icon: Icons.logout,
                      title: context.l10n.logout,
                      onTap: () => _showLogoutDialog(context),
                    ),
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
    );
  }

  void _handleLogoutState(BuildContext context, ProfileStates state) {
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
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LanguageChangeDialog(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ProfileViewModel>(),
        child: const LogoutDialog(),
      ),
    );
  }
}

class _NotificationAction extends StatelessWidget {
  const _NotificationAction();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 28),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.red,
              ),
              child: const Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorStateWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorStateWidget({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: const TextStyle(color: AppColors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(context.l10n.retryButton),
          ),
        ],
      ),
    );
  }
}
