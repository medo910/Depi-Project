import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/widgets/custom_button.dart';
import 'package:depi_app/core/widgets/custom_form_text_field.dart';
import 'package:depi_app/core/widgets/show_custom_alert_dialog.dart';
import 'package:depi_app/core/widgets/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(_emailCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAuth,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeftLong,
            color: Colors.black,
          ),
          onPressed: () => AppRouter.router.go(AppRouter.kLogin),
        ),
        title: const Text(
          'Reset Password',
          style: AppStyles.styleSemiBold20Dark,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.accent.withOpacity(0.1),
              child: Icon(
                Icons.mail_outline,
                color: AppColors.accent,
                size: 40,
              ),
            ),
            const SizedBox(height: 30),
            Text("Reset your password", style: AppStyles.styleSemiBold20Dark),
            const SizedBox(height: 8),
            Text(
              'Enter your email and we will send you a link to reset your password.',
              style: AppStyles.styleRegular14Muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Form(
              key: _formKey,
              child: CustomFormTextField(
                labelText: 'Email',
                hintText: 'Enter your email',
                fieldType: FieldType.email,
                prefixIcon: Icons.email_outlined,
                controller: _emailCtrl,
              ),
            ),
            const SizedBox(height: 20),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  showSnackBar(context, "${state.message}", Colors.red);
                } else if (state is AuthPasswordReset) {
                  showCustomAlertDialog(context, _emailCtrl.text.trim());
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return Column(
                  children: [
                    CustomButton(
                      backgroundColor: AppColors.accent,
                      text: "Send reset email",
                      onPressed: _submit,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
