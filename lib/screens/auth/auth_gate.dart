import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import 'auth_screen.dart';

class AuthGate extends StatelessWidget {
  final Widget child;
  const AuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // Still loading session from storage
        if (auth.isLoading) {
          return const Scaffold(
            backgroundColor: ElectraTheme.background,
            body: Center(
              child: CircularProgressIndicator(color: ElectraTheme.primary),
            ),
          );
        }
        // Not logged in — show auth screen
        if (!auth.isAuthenticated) {
          return const AuthScreen();
        }
        // Logged in — show the app
        return child;
      },
    );
  }
}
