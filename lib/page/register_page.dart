import 'package:ai_overthinking/service/firebase_service.dart';
import 'package:ai_overthinking/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<ShadFormState>();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ShadForm(
          key: formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadInputFormField(
                  id: 'email',
                  label: const Text('Register'),
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
                    child: const Text('Register'),
                    onPressed: () async {
                      if (formKey.currentState!.saveAndValidate()) {
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: formKey.currentState!.value['email'],
                            password: formKey.currentState!.value['password'],
                          );
                          if (credential.user != null) {
                            FirebaseService()
                                .createUser(
                              email: credential.user?.email,
                              quota: 3,
                            )
                                .then((value) {
                              if (context.mounted) context.go('/');
                            }).catchError(
                              (error) {
                                if (context.mounted) {
                                  toastError(
                                    context,
                                    message: error.message,
                                  );
                                }
                              },
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (context.mounted) {
                            toastError(context, message: e.message);
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
                        text: 'Already Have Account?',
                        style: ShadTheme.of(context).textTheme.muted,
                      ),
                      TextSpan(
                        text: ' Login',
                        style: ShadTheme.of(context)
                            .textTheme
                            .muted
                            .copyWith(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.go('/login'),
                      ),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
