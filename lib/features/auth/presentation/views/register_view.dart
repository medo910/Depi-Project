import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:depi_app/core/widgets/custom_button.dart';
import 'package:depi_app/core/widgets/custom_form_text_field.dart';
import 'package:depi_app/core/widgets/show_snack_bar.dart';
import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAuth,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: const Text(
                      'Register',
                      style: AppStyles.styleSemiBold24Dark,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomFormTextField(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    fieldType: FieldType.name,
                    prefixIcon: Icons.person_outline,
                    controller: fullNameController,
                  ),
                  const SizedBox(height: 12),
                  CustomFormTextField(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    fieldType: FieldType.email,
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                  ),
                  const SizedBox(height: 12),
                  CustomFormTextField(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    fieldType: FieldType.password,
                    prefixIcon: Icons.lock_outline,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 12),
                  CustomFormTextField(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    fieldType: FieldType.password,
                    prefixIcon: Icons.lock_outline,
                    controller: confirmPasswordController,
                    originalPassword: passwordController,
                  ),
                  const SizedBox(height: 24),

                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        showSnackBar(context, state.message, Colors.red);
                      } else if (state is AuthSuccess) {
                        showSnackBar(
                          context,
                          "Registration Successful",
                          Colors.green,
                        );
                        AppRouter.router.go(AppRouter.kLogin);
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          CustomButton(
                            backgroundColor: AppColors.accent,
                            text: 'Register',
                            isLoading:
                                state is AuthLoading && !state.isGoogleLogin,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signUp(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  fullNameController.text.trim(),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '----------------------- OR -----------------------',
                            style: AppStyles.styleRegular14Muted.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            icon: FontAwesomeIcons.google,
                            backgroundColor: AppColors.accent,
                            text: 'Sign in with Google',
                            isLoading:
                                state is AuthLoading && state.isGoogleLogin,
                            onPressed: () {
                              context.read<AuthCubit>().signInWithGoogle(
                                context,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: AppStyles.styleRegular16Muted,
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRouter.router.go(AppRouter.kLogin);
                        },
                        child: const Text(
                          '  Login',
                          style: AppStyles.styleMedium14Primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
