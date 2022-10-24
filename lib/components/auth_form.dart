import 'package:flutter/material.dart';

enum AuthMode { SINGUP, LOGIN }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  AuthMode _authMode = AuthMode.LOGIN;
  Map<String, String> _authData = {'email': '', 'password': ''};

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState?.save();

    if (_isLoading) {
    } else {}

    setState(() {
      _isLoading = false;
    });
  }

  bool _isLogin() => _authMode == AuthMode.LOGIN;

  bool _isSingup() => _authMode == AuthMode.SINGUP;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode == AuthMode.SINGUP;
      } else {
        _authMode == AuthMode.LOGIN;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
          height: _isLogin() ? 310 : 400,
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
              if (_isSingup())
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 25)),
                    onPressed: _submit,
                    child: Text(
                        _authMode == AuthMode.LOGIN ? 'ENTRAR' : 'REGISTRAR')),
              Spacer(),
              TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      _isLogin() ? 'Registre-se agora' : 'Faça o login agora'))
            ]),
          )),
    );
  }
}
