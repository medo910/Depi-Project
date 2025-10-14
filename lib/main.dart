import 'package:depi_app/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DepiApp());
}

class DepiApp extends StatelessWidget {
  const DepiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      title: 'Kite Shopping',
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
