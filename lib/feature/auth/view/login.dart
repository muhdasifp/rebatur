import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/core/theme/app_color.dart';
import 'package:machine_test/core/widget/app_field.dart';
import 'package:machine_test/core/widget/button.dart';
import 'package:machine_test/feature/auth/provider/auth_provider.dart';
import 'package:machine_test/feature/auth/provider/auth_state.dart';
import 'package:machine_test/feature/auth/view/register.dart';
import 'package:machine_test/feature/home/view/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (_, next) {
      if (next is AuthSuccess) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
      if (next is AuthError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              content: Text(
                next.message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 15,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryBlue,
                      ),
                    ),

                    AppField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                        ).hasMatch(value)) {
                          return 'Email is invalid';
                        }
                        return null;
                      },
                      label: 'Email Id',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                    ),
                    AppField(
                      label: 'Enter your Password',
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      prefixIcon: Icons.lock_open_outlined,
                    ),

                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, child) {
                              final state = ref.watch(authProvider);
                              return PrimaryButton(
                                label: 'Login',
                                onTap: _login,
                                isLoading: state is AuthLoading,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PrimaryButton(label: 'Clear', onTap: _clear),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Create new Account',
                          style: TextStyle(
                            color: AppColor.primaryBlue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clear() {
    _emailController.clear();
    _passwordController.clear();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ref
          .read(authProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }
}
