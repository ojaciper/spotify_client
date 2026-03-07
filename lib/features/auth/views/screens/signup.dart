import 'package:flutter/material.dart';
import 'package:flutter_spotify_clone/core/themes/app_pallete.dart';
import 'package:flutter_spotify_clone/features/auth/views/widgets/auth_button.dart';
import 'package:flutter_spotify_clone/features/auth/views/widgets/custom_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Sign Up. ",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            CustomField(hintText: "Name"),
            const SizedBox(height: 15),
            CustomField(hintText: "Email"),
            const SizedBox(height: 15),
            CustomField(hintText: "Password"),
            const SizedBox(height: 20),
            AuthButton(),
            const SizedBox(height: 20),
            RichText(
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
          ],
        ),
      ),
    );
  }
}
