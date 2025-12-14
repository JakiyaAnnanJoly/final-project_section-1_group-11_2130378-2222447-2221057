import 'package:expense_calculator_demo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/expense_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'firebase_options.dart';


void main () async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProxyProvider<AuthProvider, ExpenseProvider>(
          create: (context) {
            final authProvider = context.read<AuthProvider>();


            final String initialUid = authProvider.currentUser?.uid ?? '';

            return ExpenseProvider();
          },

          update: (context, authProvider, existingExpenseProvider) {
            final String newUid = authProvider.currentUser?.uid ?? '';

            if (existingExpenseProvider == null) {
              return ExpenseProvider();
            }

            existingExpenseProvider.updateUid(newUid);

            return existingExpenseProvider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: const  AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authProvider.isAuthenticated) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}