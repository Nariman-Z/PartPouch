import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import 'router.dart';

class PartPouchApp extends StatelessWidget {
  const PartPouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeProvider(),
      builder: (context, _) {
        final theme = ThemeProvider();

        return MaterialApp.router(
          title: 'PartPouch',
          debugShowCheckedModeBanner: false,
          themeMode: theme.themeMode,
          theme: AppTheme.getTheme(
            false,
            isRtl: theme.isRtl,
            activeColor: theme.activeColor,
          ),
          darkTheme: AppTheme.getTheme(
            true,
            isRtl: theme.isRtl,
            activeColor: theme.activeColor,
          ),
          locale: theme.locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('fa', 'IR'),
          ],
          routerConfig: appRouter,
        );
      },
    );
  }
}
