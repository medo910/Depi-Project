import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/widgets/custom_button.dart';
import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Iconsax.user_edit_copy,
                color: AppColors.primary,
              ),
              title: const Text("Edit Profile"),
              subtitle: const Text("Change name, email, phone, addresses"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                GoRouter.of(context).push(AppRouter.kEditProfile);
              },
            ),
            const Divider(),

            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              child: ListTile(
                leading: const Icon(
                  Iconsax.lock_copy,
                  color: AppColors.primary,
                ),
                title: const Text("Reset Password"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  GoRouter.of(context).push(AppRouter.kResetPassword);
                },
              ),
            ),
            const Divider(),

            const Spacer(),

            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSignedOut) {
                  while (GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop();
                  }
                  GoRouter.of(context).pushReplacement(AppRouter.kLogin);
                }
              },
              child: CustomButton(
                text: "Log Out",
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
