import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/auth.dart';

import '../exception/AuthException.dart';

enum AuthMode { SIGNUP, LOGIN }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.LOGIN;
  Map<String, String> _authData = {'email': '', 'password': ''};
  AnimationController? _animationController;
  Animation<Size>? _heightAnimation;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    _heightAnimation = Tween(
      begin: const Size(double.infinity, 310),
      end: const Size(double.infinity, 400),
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        await auth.login(
            _authData['email'].toString(), _authData['password'].toString());
      } else {
        await auth.signup(
            _authData['email'].toString(), _authData['password'].toString());
      }
    } on AuthException catch (e) {
      _showErrorDialog(e.message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Ocorreu um erro'),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text('Fechar'))
              ],
            ));
  }

  bool _isLogin() => _authMode == AuthMode.LOGIN;

  bool _isSignup() => _authMode == AuthMode.SIGNUP;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.SIGNUP;
        _animationController?.forward();
      } else {
        _authMode = AuthMode.LOGIN;
        _animationController?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AnimatedBuilder(
        animation: _heightAnimation!,
        builder: (ctx, child) => Container(
            height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
            width: deviceSize.width * 0.85,
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (data) => _authData['email'] = data ?? '',
                    validator: (data) {
                      final email = data ?? '';
                      if (email.trim().isEmpty || !email.contains('@')) {
                        return 'Informe uma email valido';
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (data) => _authData['password'] = data ?? '',
                    controller: _passwordController,
                    validator: (data) {
                      final password = data ?? '';
                      if (password.trim().isEmpty || password.length < 2) {
                        return 'Informe uma senha valida';
                      }
                    }),
                AnimatedContainer(
                  constraints: BoxConstraints(
                      minHeight: _isLogin() ? 0 : 60,
                      maxHeight: _isLogin() ? 0 : 120),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirmar Senha'),
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        validator: _isLogin()
                            ? null
                            : (data) {
                                final password = data ?? '';
                                if (password != _passwordController.text) {
                                  return 'Senhas informadas não conferem';
                                }
                              },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 25)),
                      onPressed: _submit,
                      child: Text(_authMode == AuthMode.LOGIN
                          ? 'ENTRAR'
                          : 'REGISTRAR')),
                Spacer(),
                TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(_isLogin()
                        ? 'Registre-se agora'
                        : 'Faça o login agora'))
              ]),
            )),
      ),
    );
  }
}
