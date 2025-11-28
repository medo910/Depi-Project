import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/widgets/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:depi_app/core/widgets/custom_form_text_field.dart';
import 'package:depi_app/core/widgets/custom_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final theme = Theme.of(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Login', style: theme.textTheme.displaySmall),
                  ),
                  const SizedBox(height: 40),
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
                    isLogin: true,
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () {
                      context.push(AppRouter.kForgotPassword);
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        showSnackBar(context, state.message, Colors.red);
                      } else if (state is AuthSuccess) {
                        showSnackBar(context, "Login Successful", Colors.green);
                        AppRouter.router.go(AppRouter.kHome);
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          CustomButton(
                            backgroundColor: Theme.of(context).primaryColor,
                            text: 'Login',
                            isLoading:
                                state is AuthLoading && !state.isGoogleLogin,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signIn(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '----------------------- OR -----------------------',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            icon: FontAwesomeIcons.google,
                            backgroundColor: theme.primaryColor,
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
                      Text(
                        'Don\'t have an account?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRouter.router.go(AppRouter.kRegister);
                        },
                        child: Text(
                          '  Register',
                          style: theme.textTheme.labelLarge,
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
