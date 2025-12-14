// import 'package:flutter/material.dart';
// import 'package:lib/main.dart';
//
//
// void main() {
//   runApp(const MyApp());
// }
//
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => ExpenseProvider()),
//       ],
//       child: MaterialApp(
//         title: 'Expense Calculator',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.deepPurple,
//         ),
//         home: const LoginScreen(),
//         routes: {
//           '/home': (context) => const HomeScreen(),
//           '/login': (context) => const LoginScreen(),
//           '/signup': (context) => const SignupScreen(),
//         },
//       ),
//     );
//   }
// }