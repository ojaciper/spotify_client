import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/core/themes/app_pallete.dart';
import 'package:flutter_spotify_clone/core/utils.dart';
import 'package:flutter_spotify_clone/core/widget/loader.dart';
import 'package:flutter_spotify_clone/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter_spotify_clone/features/auth/views/screens/login_screen.dart';
import 'package:flutter_spotify_clone/features/auth/views/widgets/auth_button.dart';
import 'package:flutter_spotify_clone/core/widget/custom_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewModelProvider.select((s) => s.isLoading),
    );
    debugPrint(isLoading.toString());
    // listen to state
    ref.listen(authViewModelProvider, (prev, next) {
      next.when(
        data: (user) {
          showSnackBar(context, "Account created successfully! Please login.");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },

        error: (error, st) => showSnackBar(context, error.toString()),
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
                      "Sign Up. ",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomField(hintText: "Name", controller: _nameController),
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
                        if (formKey.currentState!.validate()) {
                          await ref
                              .watch(authViewModelProvider.notifier)
                              .signUpUser(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                        }
                      },
                      buttonText: "Sign Up",
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ),

                      child: RichText(
                        text: TextSpan(
                          text: "Already have account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: "Sign in",
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
