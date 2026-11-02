import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';
import 'pp_card.dart';

/// Neumorphic stat metric card matching Ambinet design guidelines.
class PpStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const PpStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final effectiveIconColor = iconColor ?? theme.activeColor;
    final effectiveValueColor = valueColor ?? theme.textColor;
    final formattedValue = theme.formatNumber(value);

    return PpCard(
      onTap: onTap == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onTap!();
            },
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      borderRadius: BorderRadius.circular(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              // Raised neumorphic icon pod
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: theme.isDark
                      ? const Color(0xFF111E2B)
                      : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: effectiveIconColor.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: theme.isDark ? 0.25 : 0.06,
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(icon, size: 19, color: effectiveIconColor),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment:
                theme.isRtl ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              formattedValue,
              style: theme.textStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: effectiveValueColor,
                letterSpacing: -0.5,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: theme.textStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.subTextColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
