import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/partpouch_logo_title.dart';
import '../../settings/data/app_settings_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    await ref.read(appSettingsRepositoryProvider).setOnboardingCompleted(true);
    if (mounted && GoRouter.maybeOf(context) != null) {
      context.go('/');
    }
  }

  void _onNext(int totalPages) {
    if (_currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    final pages = [
      _OnboardingItem(
        imagePath: 'assets/images/onboarding_01.webp',
        title: theme.translate('onboarding_title_1'),
        description: theme.translate('onboarding_desc_1'),
      ),
      _OnboardingItem(
        imagePath: 'assets/images/onboarding_02.webp',
        title: theme.translate('onboarding_title_2'),
        description: theme.translate('onboarding_desc_2'),
      ),
      _OnboardingItem(
        imagePath: 'assets/images/onboarding_03.webp',
        title: theme.translate('onboarding_title_3'),
        description: theme.translate('onboarding_desc_3'),
      ),
    ];

    final isLastPage = _currentPage == pages.length - 1;

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.primaryColor,
          body: SafeArea(
            child: Column(
              children: [
                // Top Bar with Skip Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              'assets/icons/app_icon_512.webp',
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const PartPouchBrandTitle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0,
                          ),
                        ],
                      ),
                      if (!isLastPage)
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: Text(
                            theme.translate('skip'),
                            style: theme.textStyle(
                              color: theme.subTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 48),
                    ],
                  ),
                ),

                // PageView Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Illustration
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 320,
                                    maxWidth: 320,
                                  ),
                                  child: Image.asset(
                                    page.imagePath,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Headline
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Text(
                                    page.title,
                                    textAlign: TextAlign.center,
                                    style: theme.textStyle(
                                      color: theme.textColor,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      height: 1.25,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    page.description,
                                    textAlign: TextAlign.center,
                                    style: theme.textStyle(
                                      color: theme.subTextColor,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Navigation Area: Dots + Action Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(pages.length, (index) {
                          final isActive = _currentPage == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 22 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? theme.activeColor
                                  : theme.borderColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 28),

                      // Next / Get Started Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => _onNext(pages.length),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.activeColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            isLastPage
                                ? theme.translate('get_started')
                                : theme.translate('next'),
                            style: theme.textStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _OnboardingItem {
  final String imagePath;
  final String title;
  final String description;

  const _OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
