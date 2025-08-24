import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/core/theme/app_color.dart';
import 'package:machine_test/core/widget/app_field.dart';
import 'package:machine_test/core/widget/button.dart';
import 'package:machine_test/feature/auth/provider/auth_provider.dart';
import 'package:machine_test/feature/auth/provider/auth_state.dart';


class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (_, next) {
      if (next is AuthSuccess) {
        Navigator.pop(context);
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
        ),
      ),
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
                      'Register',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryBlue,
                      ),
                    ),

                    AppField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                      label: 'Name',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
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
                      label: 'Password',
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

                    AppField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password is required';
                        }
                        if (value != _passwordController.text) {
                          return 'Confirm Password does not match';
                        }
                        return null;
                      },
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      prefixIcon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, child) {
                              final state = ref.watch(authProvider);
                              return PrimaryButton(
                                label: 'Create',
                                onTap: _create,
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
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _create() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ref
          .read(authProvider.notifier)
          .register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            passwordConfirmation: _confirmPasswordController.text.trim(),
          );
    }
  }
}
