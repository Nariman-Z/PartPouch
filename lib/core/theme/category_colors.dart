import 'package:flutter/material.dart';

/// Centralized category colors for electronics components across PartPouch.
/// Every part category has a signature color matching standard workshop conventions,
/// with an 'Other' / unmapped category color of pure white.
class CategoryColors {
  CategoryColors._();

  // Perfect-Contrast Signature category colors matching user's template
  static const Color resistor = Color(0xFFFFAE1A); // Resistors: Warm Sun Amber (Template)
  static const Color capacitor = Color(0xFF00C7F2); // Capacitors: Electric Sky Cyan (Template)
  static const Color microcontroller =
      Color(0xFF5B67F5); // MCUs & Dev Boards: Royal Iris Purple (Template)
  static const Color transistor =
      Color(0xFF7CD428); // Transistors & MOSFETs: Fresh Leaf Lime Green (Template)
  static const Color opto =
      Color(0xFFFF4838); // Optoelectronics & LEDs: Coral Vermilion Red (Template)
  static const Color hardware =
      Color(0xFF7E848D); // Hardware & Fasteners: Slate Taupe Gray (Template)

  static const Color diode = Color(0xFFFFEA00); // Diodes & Rectifiers: Bright Canary Yellow
  static const Color display =
      Color(0xFFE024C3); // Displays & Screens: Hot Neon Fuchsia
  static const Color inductor = Color(0xFFA838FF); // Inductors & Coils: Electric Orchid Violet
  static const Color power =
      Color(0xFFFF6F00); // Power & Regulators: Blazing Flame Orange
  static const Color sensor =
      Color(0xFF00897B); // Sensors & Telemetry: Deep Marine Teal
  static const Color module =
      Color(0xFF00E5A3); // Modules & Breakouts: Radiant Mint Turquoise
  static const Color semiconductor =
      Color(0xFF1A237E); // ICs & Logic: Deep Midnight Navy
  static const Color switchRelay =
      Color(0xFFFF4081); // Switches & Relays: Electric Rose Pink
  static const Color connector =
      Color(0xFF8D6E63); // Connectors & Headers: Saddle Ochre Bronze
  static const Color audio =
      Color(0xFF7B1FA2); // Audio & Buzzers: Imperial Amethyst
  static const Color other = Color(0xFFCFD8DC); // Other / Unmapped: Polished Platinum Steel

  /// Pre-defined standard categories with their assigned colors for reports and legends
  static const Map<String, Color> standardCategoryMap = {
    'Resistors': resistor,
    'Capacitors': capacitor,
    'Inductors': inductor,
    'Microcontroller': microcontroller,
    'ICs & Semiconductors': semiconductor,
    'Sensors': sensor,
    'Diodes': diode,
    'Transistors': transistor,
    'Optoelectronics': opto,
    'Displays': display,
    'Power & Regulators': power,
    'Modules & Shields': module,
    'Connectors': connector,
    'Switches & Relays': switchRelay,
    'Audio & Sound': audio,
    'Hardware & Misc': hardware,
    'Other': other,
  };

  /// Returns the signature color for a given category name (case-insensitive substring match).
  static Color getColor(String? category) {
    if (category == null || category.trim().isEmpty) {
      return other;
    }
    final lower = category.trim().toLowerCase();

    if (lower.contains('resistor')) {
      return resistor;
    } else if (lower.contains('display') ||
        lower.contains('screen') ||
        lower.contains('oled') ||
        lower.contains('tft') ||
        lower.contains('lcd')) {
      return display;
    } else if (lower.contains('cap') || lower.contains('electrolytic')) {
      return capacitor;
    } else if (lower.contains('inductor') ||
        lower.contains('coil') ||
        lower.contains('choke') ||
        lower.contains('ferrite')) {
      return inductor;
    } else if (lower.contains('micro') ||
        lower.contains('mcu') ||
        lower.contains('esp') ||
        lower.contains('cpu') ||
        lower.contains('arduino') ||
        lower.contains('stm32') ||
        lower.contains('rp2040')) {
      return microcontroller;
    } else if (lower.contains('ic') ||
        lower.contains('semiconductor') ||
        lower.contains('logic') ||
        lower.contains('fpga') ||
        lower.contains('timer') ||
        lower.contains('shift register') ||
        lower.contains('uart')) {
      return semiconductor;
    } else if (lower.contains('sensor') ||
        lower.contains('telemetry') ||
        lower.contains('bme') ||
        lower.contains('mpu') ||
        lower.contains('imu') ||
        lower.contains('temp')) {
      return sensor;
    } else if (lower.contains('diode') ||
        lower.contains('rectifier') ||
        lower.contains('zener') ||
        lower.contains('schottky')) {
      return diode;
    } else if (lower.contains('transistor') ||
        lower.contains('mosfet') ||
        lower.contains('bjt') ||
        lower.contains('igbt')) {
      return transistor;
    } else if (lower.contains('opto') ||
        lower.contains('led') ||
        lower.contains('laser') ||
        lower.contains('neopixel') ||
        lower.contains('photodiode')) {
      return opto;
    } else if (lower.contains('switch') ||
        lower.contains('relay') ||
        lower.contains('button')) {
      return switchRelay;
    } else if (lower.contains('audio') ||
        lower.contains('buzzer') ||
        lower.contains('speaker') ||
        lower.contains('sound')) {
      return audio;
    } else if (lower.contains('power') ||
        lower.contains('regulator') ||
        lower.contains('battery') ||
        lower.contains('charger') ||
        lower.contains('converter') ||
        lower.contains('ldo')) {
      return power;
    } else if (lower.contains('module') ||
        lower.contains('shield') ||
        lower.contains('breakout') ||
        lower.contains('driver') ||
        lower.contains('hat')) {
      return module;
    } else if (lower.contains('connector') ||
        lower.contains('header') ||
        lower.contains('cable') ||
        lower.contains('terminal') ||
        lower.contains('socket') ||
        lower.contains('plug') ||
        lower.contains('jack')) {
      return connector;
    } else if (lower.contains('hardware') ||
        lower.contains('screw') ||
        lower.contains('insert') ||
        lower.contains('standoff') ||
        lower.contains('wire') ||
        lower.contains('misc')) {
      return hardware;
    }

    return other;
  }

  /// Returns a luminous background tint for container surfaces (20-24% in dark, 12% in light).
  static Color getContainerColor(String? category, {bool isDark = true}) {
    final baseColor = getColor(category);
    if (baseColor == other) {
      return isDark
          ? Colors.white.withValues(alpha: 0.16)
          : Colors.black.withValues(alpha: 0.06);
    }
    return baseColor.withValues(alpha: isDark ? 0.22 : 0.12);
  }

  /// Returns a crisp outline border color for badges or chips.
  static Color getBorderColor(String? category, {bool isDark = true}) {
    final baseColor = getColor(category);
    if (baseColor == other) {
      return isDark
          ? Colors.white.withValues(alpha: 0.45)
          : Colors.black.withValues(alpha: 0.25);
    }
    return baseColor.withValues(alpha: isDark ? 0.65 : 0.40);
  }

  /// Returns an appropriate foreground/text color that glows brilliantly on dark backgrounds
  /// and maintains strong contrast on light backgrounds.
  static Color getForegroundColor(String? category, {bool isDark = true}) {
    final baseColor = getColor(category);
    if (baseColor == other) {
      return isDark ? Colors.white : const Color(0xFF1E293B);
    }
    if (!isDark) {
      return _darken(baseColor, 0.12);
    }
    return _lighten(baseColor, 0.18);
  }

  static Color _lighten(Color color, [double amount = 0.18]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  static Color _darken(Color color, [double amount = 0.12]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// Builds a compact, elegant category badge with a color-coded dot indicator.
  static Widget buildBadge(
    String category, {
    required bool isDark,
    double fontSize = 11,
  }) {
    final fg = getForegroundColor(category, isDark: isDark);
    final dotColor = getColor(category);
    final bg = getContainerColor(category, isDark: isDark);
    final border = getBorderColor(category, isDark: isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: dotColor == other
                  ? (isDark ? Colors.white : const Color(0xFF718096))
                  : dotColor,
              shape: BoxShape.circle,
              boxShadow: isDark && dotColor != other
                  ? [
                      BoxShadow(
                        color: dotColor.withValues(alpha: 0.6),
                        blurRadius: 4,
                        spreadRadius: 0.5,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            category,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the singular, user-friendly component type for a category.
  static String getSingularCategory(String category, {bool isPersian = false}) {
    final cat = category.trim();
    final lower = cat.toLowerCase();
    if (lower.startsWith('resistor')) return isPersian ? 'مقاومت' : 'Resistor';
    if (lower.startsWith('capacitor')) return isPersian ? 'خازن' : 'Capacitor';
    if (lower.startsWith('inductor')) return isPersian ? 'سلف' : 'Inductor';
    if (lower.startsWith('diode')) return isPersian ? 'دیود' : 'Diode';
    if (lower.startsWith('transistor')) return isPersian ? 'ترانزیستور' : 'Transistor';
    if (lower.startsWith('microcontroller') || lower == 'mcu') return isPersian ? 'میکروکنترلر' : 'Microcontroller';
    if (lower.startsWith('display')) return isPersian ? 'نمایشگر' : 'Display';
    if (lower.startsWith('sensor')) return isPersian ? 'سنسور' : 'Sensor';
    if (lower.startsWith('connector')) return isPersian ? 'کانکتور' : 'Connector';
    if (lower.contains('switch') || lower.contains('relay')) return isPersian ? 'کلید و رله' : 'Switch / Relay';
    if (lower.contains('power') || lower.contains('regulator')) return isPersian ? 'تغذیه و رگولاتور' : 'Power / Regulator';
    if (lower.contains('audio') || lower.contains('sound')) return isPersian ? 'صوتی' : 'Audio';
    if (lower.contains('ic') || lower.contains('semiconductor') || lower.contains('logic')) return isPersian ? 'آی‌سی' : 'IC';
    if (lower.contains('opto') || lower.contains('led')) return isPersian ? 'ال‌ای‌دی' : 'Opto / LED';
    if (lower.contains('module') || lower.contains('shield')) return isPersian ? 'ماژول' : 'Module';
    if (lower.contains('hardware') || lower.contains('fastener')) return isPersian ? 'سخت‌افزار' : 'Hardware';
    if (lower.endsWith('s') && lower.length > 3) {
      return cat.substring(0, cat.length - 1);
    }
    return cat.isNotEmpty ? cat : (isPersian ? 'قطعه' : 'Component');
  }

  /// Extracts the clean component value/model without redundant category repetition.
  static String formatComponentValue(String name, String category) {
    var val = name.trim();
    final singular = getSingularCategory(category).toLowerCase();
    final plural = category.trim().toLowerCase();

    for (final w in [plural, singular]) {
      if (w.length < 3) continue;
      final pattern = RegExp('\\b${RegExp.escape(w)}\\b', caseSensitive: false);
      val = val.replaceAll(pattern, '').trim();
    }
    if (plural.contains('regulator') || singular.contains('regulator')) {
      val = val.replaceAll(RegExp(r'\b(regulator|voltage regulator)\b', caseSensitive: false), '').trim();
    }
    val = val.replaceAll(RegExp(r'\s+'), ' ');
    val = val.replaceAll(RegExp(r'^[-–—•,:\s]+|[-–—•,:\s]+$'), '').trim();
    return val.isNotEmpty ? val : name;
  }

  /// Formats the primary title for a component card:
  /// Component Type (e.g. Resistor) • Value / Model (e.g. 10kΩ 1%)
  static Widget buildTitleRichText({
    required String name,
    required String category,
    required Color textColor,
    Color? subTextColor,
    double fontSize = 14,
    FontWeight typeWeight = FontWeight.bold,
    FontWeight valueWeight = FontWeight.w600,
    bool isPersian = false,
  }) {
    final type = getSingularCategory(category, isPersian: isPersian);
    final val = formatComponentValue(name, category);
    final effectiveSubColor = subTextColor ?? textColor.withValues(alpha: 0.6);

    final showDot = val.isNotEmpty && val.toLowerCase() != type.toLowerCase();

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: type,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: typeWeight,
              color: textColor,
            ),
          ),
          if (showDot) ...[
            TextSpan(
              text: ' • ',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.normal,
                color: effectiveSubColor,
              ),
            ),
            TextSpan(
              text: val,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: valueWeight,
                color: textColor,
              ),
            ),
          ],
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Returns the corresponding semantic icon for any component category.
  static IconData getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('micro') ||
        lower.contains('mcu') ||
        lower.contains('esp') ||
        lower.contains('cpu') ||
        lower.contains('arduino') ||
        lower.contains('stm32')) {
      return Icons.developer_board_rounded;
    } else if (lower.contains('resistor')) {
      return Icons.linear_scale_rounded;
    } else if (lower.contains('display') ||
        lower.contains('screen') ||
        lower.contains('oled') ||
        lower.contains('lcd') ||
        lower.contains('tft')) {
      return Icons.tv_rounded;
    } else if (lower.contains('cap')) {
      return Icons.battery_charging_full_rounded;
    } else if (lower.contains('inductor') || lower.contains('coil')) {
      return Icons.waves_rounded;
    } else if (lower.contains('diode') || lower.contains('rectifier')) {
      return Icons.arrow_forward_rounded;
    } else if (lower.contains('led') || lower.contains('opto')) {
      return Icons.lightbulb_outline_rounded;
    } else if (lower.contains('sensor')) {
      return Icons.sensors_rounded;
    } else if (lower.contains('transistor') || lower.contains('mosfet')) {
      return Icons.schema_rounded;
    } else if (lower.contains('power') ||
        lower.contains('regulator') ||
        lower.contains('converter') ||
        lower.contains('ldo')) {
      return Icons.bolt_rounded;
    } else if (lower.contains('switch') || lower.contains('relay') || lower.contains('button')) {
      return Icons.toggle_on_rounded;
    } else if (lower.contains('module') || lower.contains('shield') || lower.contains('breakout')) {
      return Icons.extension_rounded;
    } else if (lower.contains('connector') ||
        lower.contains('header') ||
        lower.contains('terminal') ||
        lower.contains('plug') ||
        lower.contains('jack') ||
        lower.contains('socket') ||
        lower.contains('usb')) {
      return Icons.cable_rounded;
    } else if (lower.contains('audio') || lower.contains('sound') || lower.contains('speaker') || lower.contains('buzzer')) {
      return Icons.volume_up_rounded;
    } else if (lower.contains('ic') ||
        lower.contains('semiconductor') ||
        lower.contains('chip') ||
        lower.contains('logic') ||
        lower.contains('fpga')) {
      return Icons.memory_rounded;
    } else if (lower.contains('hardware') || lower.contains('screw') || lower.contains('nut') || lower.contains('fastener')) {
      return Icons.build_rounded;
    }
    return Icons.category_rounded;
  }
}
