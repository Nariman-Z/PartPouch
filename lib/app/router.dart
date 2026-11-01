import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/inventory/presentation/add_edit_component_screen.dart';
import '../features/inventory/presentation/component_detail_screen.dart';
import '../features/inventory/presentation/inventory_screen.dart';
import '../features/inventory/presentation/low_stock_screen.dart';
import '../features/locations/presentation/location_detail_screen.dart';
import '../features/locations/presentation/locations_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/projects/presentation/project_detail_screen.dart';
import '../features/projects/presentation/projects_screen.dart';
import '../features/purchasing/presentation/create_purchase_order_screen.dart';
import '../features/purchasing/presentation/purchase_order_detail_screen.dart';
import '../features/purchasing/presentation/purchase_orders_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/scanning/presentation/qr_scanner_screen.dart';
import '../features/search/presentation/global_search_screen.dart';
import '../features/settings/presentation/screens/appearance_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/shell/presentation/main_shell.dart';
import '../features/shell/presentation/more_hub_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/stock_movements/presentation/activity_history_screen.dart';
import '../features/suppliers/presentation/suppliers_screen.dart';
import '../features/stocktake/presentation/stocktake_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _inventoryNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _locationsNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _projectsNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _moreNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        // 1. Home Dashboard
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),

        // 2. Inventory
        StatefulShellBranch(
          navigatorKey: _inventoryNavigatorKey,
          routes: [
            GoRoute(
              path: '/inventory',
              builder: (context, state) => const InventoryScreen(),
            ),
          ],
        ),

        // 3. Locations
        StatefulShellBranch(
          navigatorKey: _locationsNavigatorKey,
          routes: [
            GoRoute(
              path: '/locations',
              builder: (context, state) => const LocationsScreen(),
            ),
          ],
        ),

        // 4. Projects
        StatefulShellBranch(
          navigatorKey: _projectsNavigatorKey,
          routes: [
            GoRoute(
              path: '/projects',
              builder: (context, state) => const ProjectsScreen(),
            ),
          ],
        ),

        // 5. More Hub
        StatefulShellBranch(
          navigatorKey: _moreNavigatorKey,
          routes: [
            GoRoute(
              path: '/more',
              builder: (context, state) => const MoreHubScreen(),
            ),
          ],
        ),
      ],
    ),

    // Sub-screens (Pushed on root navigator)
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/component/add',
      builder: (context, state) => const AddEditComponentScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/component/:id',
      builder: (context, state) =>
          ComponentDetailScreen(componentId: state.pathParameters['id']!),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/component/:id/edit',
      builder: (context, state) =>
          AddEditComponentScreen(componentId: state.pathParameters['id']),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/location/:id',
      builder: (context, state) =>
          LocationDetailScreen(locationId: state.pathParameters['id']!),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/project/:id',
      builder: (context, state) =>
          ProjectDetailScreen(projectId: state.pathParameters['id']!),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/purchasing',
      builder: (context, state) => const PurchaseOrdersScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/purchasing/new',
      builder: (context, state) => const CreatePurchaseOrderScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/purchase-order/:id',
      builder: (context, state) =>
          PurchaseOrderDetailScreen(orderId: state.pathParameters['id']!),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/suppliers',
      builder: (context, state) => const SuppliersScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/stocktake',
      builder: (context, state) => const StocktakeScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/scan',
      builder: (context, state) => const QrScannerScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/search',
      builder: (context, state) => const GlobalSearchScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/low-stock',
      builder: (context, state) => const LowStockScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/activity',
      builder: (context, state) => const ActivityHistoryScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/settings/appearance',
      builder: (context, state) => const AppearanceScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);
