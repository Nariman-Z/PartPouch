import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partpouch/app/app.dart';
import 'package:partpouch/core/database/database.dart';
import 'package:partpouch/core/database/database_provider.dart';
import 'package:partpouch/features/onboarding/presentation/onboarding_screen.dart';
import 'package:partpouch/features/settings/data/app_settings_repository.dart';
import 'package:partpouch/features/splash/presentation/splash_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('SplashScreen displays branding and progress', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: SplashScreen()),
      ),
    );

    // Initial pump
    await tester.pump();
    expect(find.text('Small parts. Big projects.'), findsOneWidget);

    // Flush timers before unmounting
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('OnboardingScreen navigates across 3 steps and completes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: OnboardingScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Step 1: Organize Your Components
    expect(find.text('Organize Your\nComponents'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next -> Step 2: Track Your Inventory
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Track Your\nInventory'), findsOneWidget);

    // Tap Next -> Step 3: Multiple Locations
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Multiple\nLocations'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap Get Started -> sets setting in repository
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    final repo = AppSettingsRepository(db);
    final completed = await repo.isOnboardingCompleted();
    expect(completed, isTrue);

    // Cleanup
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets(
    'PartPouch app boots up with dark theme and bottom navigation after onboarding',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Pre-mark onboarding as completed so app navigates to main shell
      final repo = AppSettingsRepository(db);
      await repo.setOnboardingCompleted(true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const PartPouchApp(),
        ),
      );

      // Let splash finish and transition
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pumpAndSettle();

      // Verify subtitle and cards on Dashboard
      expect(find.text('Total stock at a glance'), findsOneWidget);
      expect(find.text('Total Items'), findsOneWidget);
      expect(find.text('Total Quantity'), findsOneWidget);
      expect(find.text('Inventory Value'), findsOneWidget);
      expect(find.text('Low Stock'), findsOneWidget);
      expect(find.text('Out of Stock'), findsOneWidget);
      expect(find.text('To Reorder'), findsOneWidget);
      expect(find.text('Recent Activity'), findsOneWidget);

      // Verify 5 bottom navigation destinations
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Inventory'), findsOneWidget);
      expect(find.text('Locations'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);

      // Unmount widget tree and flush Drift stream cleanup timers
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    },
  );

  testWidgets('Bottom navigation switches between primary destinations', (
    WidgetTester tester,
  ) async {
    // Pre-mark onboarding as completed
    final repo = AppSettingsRepository(db);
    await repo.setOnboardingCompleted(true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const PartPouchApp(),
      ),
    );

    // Transition past splash
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Tap Inventory tab
    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();
    expect(find.text('Search components, MPN, SKU, tags...'), findsOneWidget);

    // Tap Locations tab
    await tester.tap(find.text('Locations'));
    await tester.pumpAndSettle();
    expect(find.text('No Locations Configured'), findsOneWidget);

    // Tap Projects tab
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();
    expect(find.text('Projects & BOM'), findsOneWidget);

    // Tap More tab
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Purchase Orders'), findsOneWidget);
    expect(find.text('Suppliers & Vendors'), findsOneWidget);
    expect(find.text('Reports & Analytics'), findsOneWidget);
    expect(find.text('Stocktake & Reconciliation'), findsOneWidget);

    // Unmount widget tree and flush Drift stream cleanup timers
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('Pop-up dialogs display Add and Cancel buttons correctly', (
    WidgetTester tester,
  ) async {
    final repo = AppSettingsRepository(db);
    await repo.setOnboardingCompleted(true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const PartPouchApp(),
      ),
    );

    // Transition past splash
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Navigate to Locations tab
    await tester.tap(find.text('Locations'));
    await tester.pumpAndSettle();

    // Open Add Location dialog
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    // Verify dialog title and buttons
    expect(find.text('New Storage Location'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);

    // Close dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Navigate to Projects tab
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();

    // Open Add Project dialog
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    // Verify dialog title and buttons
    expect(find.text('Create Project'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);

    // Close dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Unmount widget tree
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}

