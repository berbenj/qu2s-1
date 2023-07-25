import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart' as fd;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = fd.FirebaseAuth.instance;
  String email = '';
  String password = '';
  // ('dev@qu2s.com', 'bravebluequantumduck')

  @override
  Widget build(BuildContext context) {
    if (auth.isSignedIn) {
      return Center(
        child: ElevatedButton(
          onPressed: () async {
            auth.signOut();
            setState(() {});
          },
          child: const Text('Logout'),
        ),
      );
    } else {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelStyle: TextStyle(color: Colors.white38),
                  labelText: 'Email',
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextField(
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelStyle: TextStyle(color: Colors.white38),
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (email.isNotEmpty && password.isNotEmpty) {
                    await auth.signIn(email, password);
                    setState(() {});
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
