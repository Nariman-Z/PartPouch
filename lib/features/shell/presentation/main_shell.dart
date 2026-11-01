import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/responsive_utils.dart';

/// Ambinet-style floating neumorphic bottom navigation bar for PartPouch.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        final isSmall = ResponsiveUtils.isSmallPhone(context);
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

        return Scaffold(
          extendBody: true,
          backgroundColor: theme.primaryColor,
          body: Stack(
            children: [
              // Screen content filling the whole viewport
              Positioned.fill(child: navigationShell),

              // Bottom Neumorphic Gradient Mask
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 120 + bottomPadding,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.primaryColor.withValues(alpha: 0.0),
                          theme.primaryColor.withValues(alpha: 0.65),
                          theme.primaryColor.withValues(alpha: 0.95),
                          theme.primaryColor,
                        ],
                        stops: const [0.0, 0.35, 0.75, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // Floating Neumorphic Navigation Pill
              Positioned(
                left: isSmall ? 12 : 16,
                right: isSmall ? 12 : 16,
                bottom: (isSmall ? 8 : 16) + bottomPadding,
                child: Container(
                  height: isSmall ? 64 : 70,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.isDark
                        ? const Color(0xFF161F28).withValues(alpha: 0.95)
                        : Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(38),
                    border: Border.all(
                      color: theme.isDark
                          ? Colors.white.withValues(alpha: 0.07)
                          : Colors.black.withValues(alpha: 0.05),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: theme.isDark ? 0.35 : 0.1,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildNavItem(
                        index: 0,
                        activeIcon: Icons.home_rounded,
                        inactiveIcon: Icons.home_outlined,
                        label: theme.translate('home'),
                        theme: theme,
                      ),
                      _buildNavItem(
                        index: 1,
                        activeIcon: Icons.inventory_2_rounded,
                        inactiveIcon: Icons.inventory_2_outlined,
                        label: theme.translate('inventory'),
                        theme: theme,
                      ),
                      _buildNavItem(
                        index: 2,
                        activeIcon: Icons.account_tree_rounded,
                        inactiveIcon: Icons.account_tree_outlined,
                        label: theme.translate('locations'),
                        theme: theme,
                      ),
                      _buildNavItem(
                        index: 3,
                        activeIcon: Icons.assignment_rounded,
                        inactiveIcon: Icons.assignment_outlined,
                        label: theme.translate('projects'),
                        theme: theme,
                      ),
                      _buildNavItem(
                        index: 4,
                        activeIcon: Icons.more_horiz_rounded,
                        inactiveIcon: Icons.more_horiz_outlined,
                        label: theme.translate('more'),
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    required ThemeProvider theme,
  }) {
    final isSelected = navigationShell.currentIndex == index;
    final color = isSelected ? theme.activeColor : theme.subTextColor;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.activeColor.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: color,
                size: 22,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: theme.textStyle(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
