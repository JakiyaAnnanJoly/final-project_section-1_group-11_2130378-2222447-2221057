// import 'package:flutter/foundation.dart';
// // import '../models/user_model.dart';
// // import '../services/auth_service.dart';
//
// /// Auth Provider for authentication state management
// class AuthProvider with ChangeNotifier {
//   final AuthService _authService = AuthService();
//
//   UserModel? _currentUser;
//   bool _isLoading = true; // Set to true initially while checking auth state
//   String? _error;
//
//
//   // Getters
//   UserModel? get currentUser => _currentUser;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isAuthenticated => _currentUser != null;
//
//   AuthProvider() {
//     // Listen to auth state changes
//     _initAuthListener();
//   }
//
//   /// Initialize auth state listener
//   void _initAuthListener() {
//
//     _authService.authStateChanges.listen((user) {
//       _currentUser = user;
//       _isLoading = false; // Auth state determined, stop loading
//       notifyListeners();
//       print('Auth State Updated: User -> ${user?.displayName}');
//     });
//   }
//
//   /// Sign up a new user
//   Future<bool> signUp({
//     required String email,
//     required String password,
//     required String firstName,
//     required String lastName,
//     required String phoneNumber,
//     String? bio,
//     String? address,
//   }) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       _currentUser = await _authService.signUp(
//         email: email,
//         password: password,
//         firstName: firstName,
//         lastName: lastName,
//         phoneNumber: phoneNumber,
//         bio: bio,
//         address: address,
//       );
//       return true;
//     } catch (e) {
//       _error = 'Sign up failed: $e';
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// Sign in existing user
//   Future<bool> signIn({
//     required String email,
//     required String password,
//   }) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       _currentUser = await _authService.signIn(email: email, password: password);
//       return true;
//     } catch (e) {
//       _error = 'Sign in failed: $e';
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// Sign out current user
//   Future<void> signOut() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       await _authService.signOut();
//       _currentUser = null;
//     } catch (e) {
//       _error = 'Sign out failed: $e';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// Update user profile
//   Future<bool> updateProfile(UserModel user) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       await _authService.updateProfile(user);
//       _currentUser = user; // Update local state immediately
//       return true;
//     } catch (e) {
//       _error = 'Update profile failed: $e';
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// Send password reset email
//   Future<bool> sendPasswordResetEmail(String email) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();
//
//     try {
//       await _authService.sendPasswordResetEmail(email);
//       return true;
//     } catch (e) {
//       _error = 'Failed to send password reset email: $e';
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// Clear error
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }