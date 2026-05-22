import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF131313),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const IgniteTunesApp());
}

class IgniteTunesApp extends StatelessWidget {
  const IgniteTunesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IgniteTunes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFddb7ff),
        scaffoldBackgroundColor: const Color(0xFF131313),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFddb7ff),
          secondary: Color(0xFFadc6ff),
          surface: Color(0xFF201f1f),
          onPrimary: Color(0xFF490080),
          onSecondary: Color(0xFF002e6a),
          onSurface: Color(0xFFe5e2e1),
          error: Color(0xFFffb4ab),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // TODO: ganti ke SplashScreen() sebelum release
    );
  }
}
