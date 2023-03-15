import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:presintation/providers/auth.dart';
import 'package:presintation/screens/overview_screen.dart';
import 'package:provider/provider.dart';

enum AuthMode {
  Login,
  SignUp,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const routeName = 'AuthenticationScreen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Login;

  bool isValidEmail(String email) {
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailRegex).hasMatch(email);
  }

  void authButton() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_authMode == AuthMode.SignUp) {
      try {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_emailController.text, _passwordController.text);
        context.goNamed(OverviewScreen.routeName);
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Something went wrong'),
            content: Text(e.message!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    } else {
      try {
        await Provider.of<Auth>(context, listen: false)
            .signIn(_emailController.text, _passwordController.text);
        context.goNamed(OverviewScreen.routeName);
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Something went wrong'),
            content: Text(e.message!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.cyan,
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 380,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/user.jpg'),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          if (_authMode == AuthMode.Login) {
                            setState(() {
                              _authMode = AuthMode.SignUp;
                            });
                          } else {
                            setState(() {
                              _authMode = AuthMode.Login;
                            });
                          }
                        },
                        child: Text(
                          _authMode == AuthMode.SignUp ? 'Login?' : 'Register?',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 156, 19, 9),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      _authMode == AuthMode.Login ? 'Login' : 'Register',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                    if (_authMode == AuthMode.Login) const SizedBox(height: 25),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      txtfield(
                        controller: _emailController,
                        hint: 'Email',
                        validator: (value) {
                          if (!isValidEmail(value!)) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      txtfield(
                          controller: _passwordController,
                          hint: 'Password',
                          validator: (value) {
                            if (value!.length < 8) {
                              return 'at least 8 characters';
                            }
                            return null;
                          },
                          isTheLast: _authMode == AuthMode.Login),
                      const SizedBox(height: 15),
                      if (_authMode != AuthMode.Login)
                        txtfield(
                          controller: _confirmController,
                          hint: 'Confirm Password',
                          validator: (value) {
                            if (value == _passwordController.text) {
                              return null;
                            }
                            return 'Please, check your password';
                          },
                          isTheLast: true,
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: authButton,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            _authMode == AuthMode.Login ? 'Login' : 'Register',
                            style: const TextStyle(
                              fontSize: 30,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField txtfield({
    required TextEditingController controller,
    required String hint,
    required String? Function(String? value) validator,
    bool isTheLast = false,
    TextInputType keyboardType = TextInputType.visiblePassword,
  }) {
    return TextFormField(
      textInputAction: isTheLast ? TextInputAction.done : TextInputAction.next,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: Colors.grey,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
/* 
SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/user.jpg'),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          if (_authMode == AuthMode.Login) {
                            setState(() {
                              _authMode = AuthMode.SignUp;
                            });
                          } else {
                            setState(() {
                              _authMode = AuthMode.Login;
                            });
                          }
                        },
                        child: Text(
                          _authMode == AuthMode.SignUp ? 'Login?' : 'Register?',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 156, 19, 9),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        _authMode == AuthMode.Login ? 'Login' : 'Register',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      if (_authMode == AuthMode.Login)
                        const SizedBox(height: 25),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              txtfield(
                                controller: _emailController,
                                hint: 'Email',
                                validator: (value) {},
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 15),
                              txtfield(
                                  controller: _passwordController,
                                  hint: 'Password',
                                  validator: (value) {},
                                  isTheLast: _authMode == AuthMode.Login),
                              const SizedBox(height: 15),
                              if (_authMode != AuthMode.Login)
                                txtfield(
                                  controller: _confirmController,
                                  hint: 'Confirm Password',
                                  validator: (value) {},
                                  isTheLast: true,
                                ),
                              const Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: () {},
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: Text(
                                        _authMode == AuthMode.Login
                                            ? 'Login'
                                            : 'Register',
                                        style: const TextStyle(
                                          fontSize: 30,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
 */