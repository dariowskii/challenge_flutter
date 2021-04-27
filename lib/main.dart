import 'package:challenge_flutter/utils/constants.dart';
import 'package:challenge_flutter/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Initializing Firebase Core.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(QuotesApp());
}

class QuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: kAppTheme,
      routes: applicationRoutes,
      initialRoute: initialRoute,
    );
  }
}
