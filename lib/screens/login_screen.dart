import 'package:challenge_flutter/utils/constants.dart';
import 'package:challenge_flutter/utils/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  final FocusNode _passFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<Map<String, dynamic>?> _loginUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = !_isLoading;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passController.text);
        setState(() {
          _isLoading = !_isLoading;
        });
        await Navigator.of(context).pushReplacementNamed(HomeScreen.id);
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = !_isLoading;
        });
        switch (e.code) {
          case 'invalid-email':
            return {'success': false, 'error': 'Mail non valida.'};
          case 'user-disabled':
            return {'success': false, 'error': 'Utente disabilitato.'};
          case 'user-not-found':
          case 'wrong-password':
            return {'success': false, 'error': 'Account non trovato.'};
          default:
            return {'success': false, 'error': 'Errore generico.'};
        }
      }
    }
  }

  @override
  void dispose() {
    // Controller
    _emailController.dispose();
    _passController.dispose();
    // Focus
    _passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentThemeData = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const BackButton(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: SizedBox(
            height: (size.height - 64 - kToolbarHeight) - 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: kTitleStyle,
                ),
                kSized20H,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: currentThemeData.primaryColor,
                        controller: _emailController,
                        onFieldSubmitted: (_) => _passFocus.requestFocus(),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Inserisci una mail...';
                          }
                          return null;
                        },
                      ),
                      kSized10H,
                      TextFormField(
                        cursorColor: currentThemeData.primaryColor,
                        controller: _passController,
                        focusNode: _passFocus,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Inserisci una password...';
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ),
                kSized40H,
                if (_isLoading) ...[
                  LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        currentThemeData.primaryColor),
                  ),
                  kSized40H,
                ],
                CustomButton(
                  backgroundColor: currentThemeData.primaryColor,
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final res = await _loginUser(context);
                          if (!(res!['success'] as bool)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(res['error'] as String)));
                          }
                        },
                  text: 'Login',
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
