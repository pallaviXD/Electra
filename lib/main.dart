import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/auth/auth_gate.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: ElectraTheme.surface,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await FirebaseService.instance.initialize();

  runApp(const ElectraApp());
}

class ElectraApp extends StatelessWidget {
  const ElectraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp.router(
        title: 'Electra – AI Election Assistant',
        debugShowCheckedModeBanner: false,
        theme: ElectraTheme.lightTheme,
        routerConfig: appRouter,
        builder: (context, child) => AuthGate(child: child ?? const SizedBox()),
      ),
    );
  }
}
