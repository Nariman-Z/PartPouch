import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partpouch/core/constants/app_colors.dart';
import 'package:partpouch/core/theme/app_theme.dart';
import 'package:partpouch/core/theme/theme_provider.dart';
import 'package:partpouch/core/utils/app_snackbar.dart';
import 'package:partpouch/core/widgets/pp_button.dart';
import 'package:partpouch/core/widgets/pp_card.dart';
import 'package:partpouch/core/widgets/pp_stat_card.dart';
import 'package:partpouch/features/settings/presentation/screens/appearance_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ThemeProvider().resetToDefaults();
  });

  group('ThemeProvider Unit Tests', () {
    test('Default values follow workshop specifications', () {
      final theme = ThemeProvider();
      expect(theme.currentLanguage, equals('English'));
      expect(theme.isRtl, isFalse);
      expect(theme.locale, equals(const Locale('en', 'US')));
      expect(theme.activeColor, equals(AppColors.accentOrange));
      expect(theme.themeMode, equals(ThemeMode.dark));
      expect(theme.isDark, isTrue);
    });

    test('ThemeMode switches correctly between light, dark, and system',
        () async {
      final theme = ThemeProvider();

      await theme.setThemeMode(ThemeMode.light);
      expect(theme.themeMode, equals(ThemeMode.light));
      expect(theme.isDark, isFalse);

      await theme.setThemeMode(ThemeMode.dark);
      expect(theme.themeMode, equals(ThemeMode.dark));
      expect(theme.isDark, isTrue);

      await theme.toggleTheme();
      expect(theme.isDark, isFalse);
    });

    test('Active accent color updates to swatches correctly', () async {
      final theme = ThemeProvider();

      await theme.setActiveColor(AppColors.accentBlue);
      expect(theme.activeColor, equals(AppColors.accentBlue));

      await theme.setActiveColor(AppColors.accentGreen);
      expect(theme.activeColor, equals(AppColors.accentGreen));
    });

    test('Persian language support and number formatting', () async {
      final theme = ThemeProvider();

      await theme.setLanguage('Persian');
      expect(theme.currentLanguage, equals('Persian'));
      expect(theme.isRtl, isTrue);
      expect(theme.locale, equals(const Locale('fa', 'IR')));

      // Number formatting to Persian digits
      expect(theme.formatNumber(12345), equals('۱۲۳۴۵'));
      expect(theme.formatNumber('Part-2026'), equals('Part-۲۰۲۶'));

      // Translation dictionary lookup
      expect(theme.translate('home'), equals('خانه'));
      expect(theme.translate('inventory'), equals('موجودی قطعات'));
      expect(theme.translate('appearance'), equals('ظاهر و پوسته'));

      // Revert to English
      await theme.setLanguage('English');
      expect(theme.isRtl, isFalse);
      expect(theme.formatNumber(12345), equals('12345'));
      expect(theme.translate('home'), equals('Home'));
    });

    test('Currency switching and Toman recalculation with exchange rate',
        () async {
      final theme = ThemeProvider();

      // Default USD
      expect(theme.currency, equals('USD'));
      expect(theme.isToman, isFalse);
      expect(theme.formatCurrency(150), equals('\$1.50'));

      // Switch to Toman with 1$ = 275k Toman
      await theme.setCurrency('TOMAN');
      await theme.setUsdToTomanRate(275000.0);
      expect(theme.currency, equals('TOMAN'));
      expect(theme.isToman, isTrue);
      expect(theme.usdToTomanRate, equals(275000.0));

      // 150 cents = $1.50 -> 1.50 * 275000 = 412,500 Toman
      expect(theme.formatCurrency(150), equals('412,500 Toman'));

      // In Persian language
      await theme.setLanguage('Persian');
      expect(theme.formatCurrency(150), equals('۴۱۲٬۵۰۰ تومان'));

      // Custom exchange rate e.g. 70,000 Toman
      await theme.setUsdToTomanRate(70000.0);
      // 100 cents = $1.00 -> 70,000 Toman
      expect(theme.formatCurrency(100), equals('۷۰٬۰۰۰ تومان'));

      // Revert to default
      await theme.resetToDefaults();
      expect(theme.currency, equals('USD'));
    });

    test('AppTheme builds both light and dark themes with activeColor', () {
      final dark = AppTheme.getTheme(
        true,
        activeColor: AppColors.accentBlue,
      );
      expect(dark.brightness, equals(Brightness.dark));
      expect(dark.colorScheme.primary, equals(AppColors.accentBlue));

      final light = AppTheme.getTheme(
        false,
        activeColor: AppColors.accentGreen,
      );
      expect(light.brightness, equals(Brightness.light));
      expect(light.colorScheme.primary, equals(AppColors.accentGreen));
    });
  });

  group('AppearanceScreen Widget Tests', () {
    testWidgets(
        'AppearanceScreen renders segmented controls, color swatches, and toggles',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: const AppearanceScreen(),
          theme: AppTheme.darkTheme,
        ),
      );
      await tester.pumpAndSettle();

      // Check sections and options
      expect(find.text('Theme Mode'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Accent Color'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('فارسی'), findsOneWidget);

      // Tap Persian language tile
      await tester.tap(find.text('فارسی'));
      await tester.pumpAndSettle();

      final theme = ThemeProvider();
      expect(theme.currentLanguage, equals('Persian'));

      // Tap Light theme option
      await tester.tap(find.text(theme.translate('light')));
      await tester.pumpAndSettle();
      expect(theme.themeMode, equals(ThemeMode.light));

      // Reset
      await theme.resetToDefaults();
      await tester.pumpAndSettle();
    });
  });

  group('AppSnackBar Widget Tests', () {
    testWidgets('AppSnackBar displays floating notification matching theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppSnackBar.show(
                      context,
                      message: 'Test notification message',
                      type: SnackBarType.success,
                    );
                  },
                  child: const Text('Show SnackBar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show SnackBar'));
      await tester.pump(); // Start SnackBar animation

      expect(find.text('Test notification message'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);

      final SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect(snackBar.behavior, equals(SnackBarBehavior.floating));
    });
  });

  group('Neumorphic Components Widget Tests', () {
    testWidgets('PpCard renders with dual-shadow neumorphic depth',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PpCard(
                child: const Text('Neumorphic Card'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Neumorphic Card'), findsOneWidget);
      final AnimatedContainer container =
          tester.widget(find.byType(AnimatedContainer));
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, greaterThanOrEqualTo(2));
    });

    testWidgets('PpButton renders neumorphic gradient and reacts to taps',
        (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PpButton(
                label: 'Save Component',
                onPressed: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Save Component'), findsOneWidget);
      await tester.tap(find.text('Save Component'));
      expect(tapped, isTrue);
    });

    testWidgets('PpStatCard renders neumorphic pod and formatted digits',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PpStatCard(
                label: 'Total Stock',
                value: '450',
                icon: Icons.inventory_2_rounded,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Total Stock'), findsOneWidget);
      expect(find.text('450'), findsOneWidget);
    });
  });
}
