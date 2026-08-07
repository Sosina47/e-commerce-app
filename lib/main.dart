import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'FakeStore E-Commerce',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          HomeScreen.routeName: (ctx) => const HomeScreen(),
        },
      ),
    );
  }
}
