import 'dart:io';

import 'package:challenge_flutter/screens/login_screen.dart';
import 'package:challenge_flutter/screens/registration_screen.dart';
import 'package:challenge_flutter/utils/constants.dart';
import 'package:challenge_flutter/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcomeScreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final navigator = Navigator.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          await SystemNavigator.pop(animated: true);
        }
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Center(
                  child: FlutterLogo(
                    size: size.width / 2,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                      text: 'Registrati',
                      onPressed: () =>
                          navigator.pushNamed(RegistrationScreen.id),
                    ),
                    kSized10H,
                    CustomButton(
                      onPressed: () => navigator.pushNamed(LoginScreen.id),
                      text: 'Login',
                      textColor: Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
