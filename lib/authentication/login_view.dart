import 'package:auth_service/auth_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oga/authentication/sign_up_view.dart';

import 'home_view.dart';

/*
class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LoginEmail(emailController: _emailController),
            const SizedBox(height: 30.0),
            _LoginPassword(passwordController: _passwordController),
            const SizedBox(height: 30.0),
            _SubmitButton(
              email: _emailController.text,
              password: _passwordController.text,
            ),
            const SizedBox(height: 30.0),
            const _CreateAccountButton(),
          ],
        ),
      ),
    );
  }
}

class _LoginEmail extends StatelessWidget {
  const _LoginEmail({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: emailController,
        decoration: const InputDecoration(hintText: 'Email'),
      ),
    );
  }
}

class _LoginPassword extends StatelessWidget {
  const _LoginPassword({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  _SubmitButton({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  final String email, password;
  final AuthService _authService = FirebaseAuthService(
    authService: FirebaseAuth.instance,
  );
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await _authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      },
      child: const Text('Login'),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SignUpView(),
          ),
        );
      },
      child: const Text('Create Account'),
    );
  }
}
*/
