import 'package:flutter/material.dart';
import 'package:flutter_spotify_clone/core/themes/app_pallete.dart';
import 'package:flutter_spotify_clone/features/auth/repository/auth_remote_respository.dart';
import 'package:flutter_spotify_clone/features/auth/views/widgets/auth_button.dart';
import 'package:flutter_spotify_clone/features/auth/views/widgets/custom_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Login. ",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 15),
              CustomField(hintText: "Email", controller: _emailController),
              const SizedBox(height: 15),
              CustomField(
                hintText: "Password",
                controller: _passwordController,
                isObScureText: true,
              ),
              const SizedBox(height: 20),
              AuthButton(
                onTap: () async {
                  final res = await AuthRemoteRespository().login(
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                  );
                  print(res);
                },
                buttonText: "Login",
              ),
              const SizedBox(height: 20),
              RichText(
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
            ],
          ),
        ),
      ),
    );
  }
}
