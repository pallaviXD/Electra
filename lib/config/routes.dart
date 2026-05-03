import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/timeline/timeline_screen.dart';
import '../screens/eligibility/eligibility_screen.dart';
import '../screens/voting_guide/voting_guide_screen.dart';
import '../screens/simulator/simulator_screen.dart';
import '../screens/candidates/candidate_compare_screen.dart';
import '../screens/manifesto/manifesto_screen.dart';
import '../screens/quiz/quiz_screen.dart';
import '../screens/misinfo/misinfo_screen.dart';
import '../screens/news/news_screen.dart';
import '../screens/results/results_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/shell/app_shell.dart';
import '../screens/polling_booth/polling_booth_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/news',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: NewsScreen(),
          ),
        ),
        GoRoute(
          path: '/tools',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: VotingGuideScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/chat',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final initialQuery = state.extra as String?;
        return ChatScreen(initialQuery: initialQuery);
      },
    ),
    GoRoute(
      path: '/timeline',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TimelineScreen(),
    ),
    GoRoute(
      path: '/eligibility',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EligibilityScreen(),
    ),
    GoRoute(
      path: '/voting-guide',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const VotingGuideScreen(),
    ),
    GoRoute(
      path: '/simulator',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SimulatorScreen(),
    ),
    GoRoute(
      path: '/candidates',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CandidateCompareScreen(),
    ),
    GoRoute(
      path: '/manifesto',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ManifestoScreen(),
    ),
    GoRoute(
      path: '/quiz',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/fact-check',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MisinfoScreen(),
    ),
    GoRoute(
      path: '/results',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ResultsScreen(),
    ),
    GoRoute(
      path: '/polling-booth',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PollingBoothScreen(),
    ),
  ],
);
