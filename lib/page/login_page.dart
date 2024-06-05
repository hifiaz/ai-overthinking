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
                        // auth.login((id: 1, name: 'John Doe'));
                        context.go('/');
                        // if (formKey.currentState!.saveAndValidate()) {
                        //   try {
                        //     if (context.mounted) {
                        //       ShadToaster.of(context).show(
                        //         ShadToast(
                        //           title: const Text('Login Success'),
                        //           description: const Text('Enjoy Due Kasir!'),
                        //           action: ShadButton.outline(
                        //             text: const Text('Back!'),
                        //             onPressed: () => ShadToaster.of(context).hide(),
                        //           ),
                        //         ),
                        //       );
                        //       Future.delayed(const Duration(seconds: 2))
                        //           .then((_) => context.go('/sync'));
                        //     }
                        //   } on AuthException catch (e) {
                        //     if (context.mounted) {
                        //       ShadToaster.of(context).show(
                        //         ShadToast(
                        //           backgroundColor: Colors.red,
                        //           title: const Text('Error'),
                        //           description: Text(e.message),
                        //         ),
                        //       );
                        //     }
                        //   }
                        // }
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
