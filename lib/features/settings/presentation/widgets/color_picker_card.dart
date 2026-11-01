import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Reusable accent color picker grid matching Ambinet design mockup.
class ColorPickerCard extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerCard({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  static final List<Color> swatchColors = AppColors.themeSwatches;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: swatchColors.map((color) {
          final isSelected = selectedColor.toARGB32() == color.toARGB32();

          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: isSelected ? 3 : 0,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 22,
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
