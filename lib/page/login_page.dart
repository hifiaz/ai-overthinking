import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<ShadFormState>();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: ShadForm(
            key: formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Ai Overthinking',
                        style: ShadTheme.of(context).textTheme.h2,
                      ),
                    ),
                  ),
                  Center(child: Image.asset('assets/robot.png', height: 230)),
                  const SizedBox(height: 10),
                  ShadInputFormField(
                    id: 'email',
                    label: const Text('Login'),
                    prefix: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: ShadImage.square(size: 16, LucideIcons.mail),
                    ),
                    placeholder: const Text('Enter your email'),
                    validator: (v) {
                      if (v.length < 2) {
                        return 'Email must be valid';
                      }
                      return null;
                    },
                  ),
                  ShadInputFormField(
                    id: 'password',
                    placeholder: const Text('Password'),
                    obscureText: obscure,
                    prefix: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: ShadImage.square(size: 16, LucideIcons.lock),
                    ),
                    validator: (v) {
                      if (v.length < 5) {
                        return 'Password must more then 5';
                      }
                      return null;
                    },
                    suffix: ShadButton.ghost(
                      width: 20,
                      height: 18,
                      padding: EdgeInsets.zero,
                      decoration: ShadDecoration.none,
                      icon: ShadImage.square(
                        size: 16,
                        obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                      ),
                      onPressed: () {
                        setState(() => obscure = !obscure);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ShadButton(
                      text: const Text('Login'),
                      onPressed: () async {
                        context.go('/');
                        if (formKey.currentState!.saveAndValidate()) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: formKey.currentState!.value['email'],
                              password: formKey.currentState!.value['password'],
                            );
                            if (credential.user != null) {
                              if (context.mounted) {
                                context.go('/');
                              }
                            }
                          } on FirebaseAuthException catch (e) {
                            if (context.mounted) {
                              ShadToaster.of(context).show(
                                ShadToast(
                                  backgroundColor: Colors.red,
                                  title: const Text('Something went wrong',
                                      style: TextStyle(color: Colors.white)),
                                  description: Text(
                                    e.message ?? 'Unknown error',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'You Dont Have Account?',
                          style: ShadTheme.of(context).textTheme.muted,
                        ),
                        TextSpan(
                          text: ' Register',
                          style: ShadTheme.of(context)
                              .textTheme
                              .muted
                              .copyWith(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.go('/register'),
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
