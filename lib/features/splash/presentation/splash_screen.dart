import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/partpouch_logo_title.dart';
import '../../settings/data/app_settings_repository.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _animationController.forward();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    // Wait for the splash animation and DB check in parallel
    final results = await Future.wait([
      Future.delayed(const Duration(milliseconds: 1500)),
      ref.read(appSettingsRepositoryProvider).isOnboardingCompleted(),
    ]);

    final isOnboardingCompleted = results[1] as bool;

    if (!mounted) return;

    if (GoRouter.maybeOf(context) != null) {
      if (isOnboardingCompleted) {
        context.go('/');
      } else {
        context.go('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.primaryColor,
          body: SafeArea(
            child: Stack(
              children: [
                // Centered Logo & Branding
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App Icon Container
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/icons/app_icon_512.webp',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Brand Name
                      const PartPouchBrandTitle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                      const SizedBox(height: 8),

                      // Tagline
                      Text(
                        theme.translate('app_tagline'),
                        style: theme.textStyle(
                          fontSize: 14,
                          color: theme.subTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Progress Bar
                Positioned(
                  left: 48,
                  right: 48,
                  bottom: 40,
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 4,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.borderColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: _progressAnimation.value.clamp(
                                  0.05,
                                  1.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.activeColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
