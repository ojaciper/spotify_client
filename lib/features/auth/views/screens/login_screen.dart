import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/core/themes/app_pallete.dart';
import 'package:flutter_spotify_clone/core/widget/loader.dart';
import 'package:flutter_spotify_clone/features/auth/repository/auth_remote_respository.dart';
import 'package:flutter_spotify_clone/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter_spotify_clone/features/auth/views/screens/signup.dart';
import 'package:flutter_spotify_clone/features/auth/views/widgets/auth_button.dart';
import 'package:flutter_spotify_clone/features/auth/views/widgets/custom_field.dart';
import 'package:fpdart/fpdart.dart' hide State;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider).isLoading;

    ref.listen(authViewModelProvider, (prev, next) {
      next.when(
        data: (date) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => LoginScreen()),
          // );
        },
        error: (error, st) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Loader()
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Login. ",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const SizedBox(height: 15),
                    CustomField(
                      hintText: "Email",
                      controller: _emailController,
                    ),
                    const SizedBox(height: 15),
                    CustomField(
                      hintText: "Password",
                      controller: _passwordController,
                      isObScureText: true,
                    ),
                    const SizedBox(height: 20),
                    AuthButton(
                      onTap: () async {
                        ref
                            .read(authViewModelProvider.notifier)
                            .login(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                      },
                      buttonText: "Login",
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Pallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
