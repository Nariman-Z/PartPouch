import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/theme_provider.dart';
import '../widgets/color_picker_card.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_section.dart';

/// Appearance settings screen with full Ambinet neumorphic controls.
class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        final overlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              theme.isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness:
              theme.isDark ? Brightness.dark : Brightness.light,
        );

        return Scaffold(
          backgroundColor: theme.primaryColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: overlayStyle,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: theme.textColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              theme.translate('appearance'),
              style: theme.textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- THEME MODE ---
                SettingsSection(title: theme.translate('theme_color')),
                _buildSegmentedTab(
                  options: [
                    {'key': 'light', 'label': theme.translate('light')},
                    {'key': 'dark', 'label': theme.translate('dark')},
                    {'key': 'system', 'label': theme.translate('system')},
                  ],
                  currentKey: _themeModeToKey(theme.themeMode),
                  onSelect: (key) {
                    HapticFeedback.selectionClick();
                    if (key == 'light') {
                      theme.setThemeMode(ThemeMode.light);
                    } else if (key == 'dark') {
                      theme.setThemeMode(ThemeMode.dark);
                    } else {
                      theme.setThemeMode(ThemeMode.system);
                    }
                  },
                  theme: theme,
                ),
                const SizedBox(height: 24),

                // --- ACCENT COLOR ---
                SettingsSection(title: theme.translate('accent_color')),
                SettingsCard(
                  children: [
                    ColorPickerCard(
                      selectedColor: theme.activeColor,
                      onColorSelected: (color) {
                        HapticFeedback.lightImpact();
                        theme.setActiveColor(color);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- LANGUAGE ---
                SettingsSection(title: theme.translate('language')),
                SettingsCard(
                  children: [
                    _buildLanguageTile(
                      label: 'English',
                      subtitle: 'US',
                      isSelected: theme.currentLanguage == 'English',
                      onTap: () {
                        HapticFeedback.selectionClick();
                        theme.setLanguage('English');
                      },
                      theme: theme,
                    ),
                    _buildLanguageTile(
                      label: theme.currentLanguage == 'Persian' ? 'فارسی' : 'Persian',
                      subtitle: 'فارسی',
                      isSelected: theme.currentLanguage == 'Persian',
                      onTap: () {
                        HapticFeedback.selectionClick();
                        theme.setLanguage('Persian');
                      },
                      theme: theme,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  String _themeModeToKey(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  Widget _buildSegmentedTab({
    required List<Map<String, String>> options,
    required String currentKey,
    required ValueChanged<String> onSelect,
    required ThemeProvider theme,
  }) {
    final isDark = theme.isDark;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C1620) : const Color(0xFFEAEFF6),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : const Color(0xFFD6E0EC),
          width: 1.1,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: const Color(0xFFCAD6E4).withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        children: options.map((opt) {
          final isSelected = opt['key'] == currentKey;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(opt['key']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? theme.activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.3 : 0.1,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  opt['label']!,
                  textAlign: TextAlign.center,
                  style: theme.textStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : theme.subTextColor,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLanguageTile({
    required String label,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeProvider theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.activeColor.withValues(alpha: 0.12)
                        : (theme.isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.black.withValues(alpha: 0.03)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.language_rounded,
                      color: isSelected ? theme.activeColor : theme.subTextColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: theme.textStyle(
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: theme.textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textStyle(
                        fontSize: 12,
                        color: theme.subTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isSelected)
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: theme.activeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.check_rounded, color: Colors.white, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
