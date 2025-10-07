import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shared_features/auth/presentation/sign_in_screen.dart';
import '../shared_features/auth/presentation/store_selection_screen.dart';
import '../shared_features/dashboard/presentation/dashboard_screen.dart';
import '../business_types/retail/features/inventory/presentation/inventory_screen.dart';
import '../business_types/retail/features/pos/presentation/pos_screen.dart' as pos;
import '../business_types/retail/features/staff/presentation/staff_screen.dart' as staff;

/// App Router configuration using go_router with a ShellRoute that hosts
/// a Material 3 NavigationBar for 5 primary tabs:
/// 1) Home/Dashboard
/// 2) POS
/// 3) Inventory
/// 4) Staff
/// 5) Settings
///
/// Each tab has its own stack (sub-routes can be added later).
/// Placeholder screens are provided to scaffold the base foundation.
///
/// Usage:
/// final router = createAppRouter();
/// MaterialApp.router(routerConfig: router, ...)
GoRouter createAppRouter({GlobalKey<NavigatorState>? rootNavigatorKey}) {
  final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'shellNavigator',
  );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: const HomeRoute().location,
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return _AppShell(child: child);
        },
        routes: [
          // Home
          GoRoute(
            path: HomeRoute.path,
            name: HomeRoute.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
            routes: [
              // Temporary auth demo routes accessible from Home
              GoRoute(
                path: 'auth/sign-in',
                name: 'auth-sign-in',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SignInScreen()),
              ),
              GoRoute(
                path: 'auth/store-selection',
                name: 'auth-store-selection',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: StoreSelectionScreen()),
              ),
            ],
          ),
          // POS
          GoRoute(
            path: PosRoute.path,
            name: PosRoute.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: pos.PosScreen()),
            routes: const [],
          ),
          // Inventory
          GoRoute(
            path: InventoryRoute.path,
            name: InventoryRoute.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: InventoryScreen()),
            routes: const [],
          ),
          // Staff
          GoRoute(
            path: StaffRoute.path,
            name: StaffRoute.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: staff.StaffScreen()),
            routes: const [],
          ),
          // Settings
          GoRoute(
            path: SettingsRoute.path,
            name: SettingsRoute.name,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsScreen()),
            routes: const [],
          ),
        ],
      ),
    ],
    // Basic error page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(state.error?.toString() ?? 'Unknown error')),
    ),
  );
}

/// Shell widget hosting the bottom NavigationBar and the routed child.
class _AppShell extends StatefulWidget {
  const _AppShell({required this.child});

  final Widget child;

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  static const _tabs = [
    _TabItem(
      routeLocation: HomeRoute.path,
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Home',
    ),
    _TabItem(
      routeLocation: PosRoute.path,
      icon: Icons.point_of_sale_outlined,
      activeIcon: Icons.point_of_sale,
      label: 'POS',
    ),
    _TabItem(
      routeLocation: InventoryRoute.path,
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
      label: 'Inventory',
    ),
    _TabItem(
      routeLocation: StaffRoute.path,
      icon: Icons.group_outlined,
      activeIcon: Icons.group,
      label: 'Staff',
    ),
    _TabItem(
      routeLocation: SettingsRoute.path,
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  int _locationToIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final idx = _tabs.indexWhere(
      (t) =>
          location == t.routeLocation ||
          location.startsWith('${t.routeLocation}/'),
    );
    return idx >= 0 ? idx : 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    final target = _tabs[index].routeLocation;
    if (GoRouter.of(context).canPop()) {
      // Ensure we navigate at shell root without stacking
      context.go(target);
    } else {
      context.go(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _locationToIndex(context);

    return Scaffold(
      body: SafeArea(top: false, child: widget.child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: [
          for (final t in _tabs)
            NavigationDestination(
              icon: Icon(t.icon),
              selectedIcon: Icon(t.activeIcon),
              label: t.label,
            ),
        ],
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.routeLocation,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final String routeLocation;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Route definitions to avoid hardcoded strings across the app.
/// Extend with typed route helpers as the app evolves.
class HomeRoute {
  static const String name = 'home';
  static const String path = '/';
  const HomeRoute();
  String get location => path;
}

class PosRoute {
  static const String name = 'pos';
  static const String path = '/pos';
  const PosRoute();
  String get location => path;
}

class InventoryRoute {
  static const String name = 'inventory';
  static const String path = '/inventory';
  const InventoryRoute();
  String get location => path;
}

class StaffRoute {
  static const String name = 'staff';
  static const String path = '/staff';
  const StaffRoute();
  String get location => path;
}

class SettingsRoute {
  static const String name = 'settings';
  static const String path = '/settings';
  const SettingsRoute();
  String get location => path;
}

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const staff.StaffScreen();
  }
}


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderScaffold(
      title: 'Settings',
      description:
          'Account, store, app preferences, support, and about/version.',
      icon: Icons.settings,
    );
    // Later: move to features/settings with sectioned settings list
  }
}

class _PlaceholderScaffold extends StatelessWidget {
  const _PlaceholderScaffold({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Card(
          elevation: 1,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 48, color: scheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () {
                      // Example action for demo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$title placeholder')),
                      );
                    },
                    child: const Text('Action'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

