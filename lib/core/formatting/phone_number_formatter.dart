import 'package:flutter/services.dart';

/// Automatically formats phone numbers with proper spacing
/// for international numbers (+1, +98, +86, etc.) and national numbers.
class PhoneNumberFormatter extends TextInputFormatter {
  const PhoneNumberFormatter();

  /// Formats any raw phone string into a well-spaced phone representation.
  static String format(String? raw) {
    if (raw == null) return '';
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';

    final bool hasPlus = trimmed.startsWith('+');
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return hasPlus ? '+' : '';

    if (hasPlus) {
      return _formatInternational(digits);
    } else {
      return _formatNational(digits);
    }
  }

  static String _formatInternational(String digits) {
    // US / Canada (+1): +1 800 346 6873
    if (digits.startsWith('1')) {
      final rest = digits.substring(1);
      if (rest.isEmpty) return '+1';
      if (rest.length <= 3) return '+1 $rest';
      if (rest.length <= 6) {
        return '+1 ${rest.substring(0, 3)} ${rest.substring(3)}';
      }
      if (rest.length <= 10) {
        return '+1 ${rest.substring(0, 3)} ${rest.substring(3, 6)} ${rest.substring(6)}';
      }
      return '+1 ${rest.substring(0, 3)} ${rest.substring(3, 6)} ${rest.substring(6, 10)} ${rest.substring(10)}';
    }

    // Iran (+98):
    // Mobile (+98 9XX XXX XXXX): +98 912 123 4567
    // Landline (+98 21 XXXX XXXX): +98 21 6675 4321
    if (digits.startsWith('98')) {
      final rest = digits.substring(2);
      if (rest.isEmpty) return '+98';

      if (rest.startsWith('9')) {
        if (rest.length <= 3) return '+98 $rest';
        if (rest.length <= 6) {
          return '+98 ${rest.substring(0, 3)} ${rest.substring(3)}';
        }
        if (rest.length <= 10) {
          return '+98 ${rest.substring(0, 3)} ${rest.substring(3, 6)} ${rest.substring(6)}';
        }
        return '+98 ${rest.substring(0, 3)} ${rest.substring(3, 6)} ${rest.substring(6, 10)} ${rest.substring(10)}';
      }

      // Landline with 2-digit provincial area code (21 Tehran, 31 Isfahan, etc.)
      if (rest.length <= 2) return '+98 $rest';
      if (rest.length <= 6) {
        return '+98 ${rest.substring(0, 2)} ${rest.substring(2)}';
      }
      if (rest.length <= 10) {
        return '+98 ${rest.substring(0, 2)} ${rest.substring(2, 6)} ${rest.substring(6)}';
      }
      return '+98 ${rest.substring(0, 2)} ${rest.substring(2, 6)} ${rest.substring(6, 10)} ${rest.substring(10)}';
    }

    // China (+86): +86 400 830 2050
    if (digits.startsWith('86')) {
      final rest = digits.substring(2);
      if (rest.isEmpty) return '+86';
      if (rest.length <= 3) return '+86 $rest';
      if (rest.length <= 7) {
        return '+86 ${rest.substring(0, 3)} ${rest.substring(3)}';
      }
      if (rest.length <= 11) {
        return '+86 ${rest.substring(0, 3)} ${rest.substring(3, 7)} ${rest.substring(7)}';
      }
      return '+86 ${rest.substring(0, 3)} ${rest.substring(3, 7)} ${rest.substring(7, 11)} ${rest.substring(11)}';
    }

    // Common 2-digit country codes
    const twoDigitCodes = {
      '20', '27', '30', '31', '32', '33', '34', '36', '39', '40', '41', '43',
      '44', '45', '46', '47', '48', '49', '51', '52', '53', '54', '55', '56',
      '57', '58', '60', '61', '62', '63', '64', '65', '66', '81', '82', '84',
      '90', '91', '92', '93', '94', '95',
    };

    final prefix2 = digits.length >= 2 ? digits.substring(0, 2) : '';
    if (twoDigitCodes.contains(prefix2)) {
      final cc = prefix2;
      final rest = digits.substring(2);
      return _chunkRest('+$cc', rest);
    }

    // 3-digit country code
    if (digits.length >= 3) {
      final cc = digits.substring(0, 3);
      final rest = digits.substring(3);
      return _chunkRest('+$cc', rest);
    }

    return '+$digits';
  }

  static String _formatNational(String digits) {
    // Iran Mobile: 0912 123 4567
    if (digits.startsWith('09')) {
      if (digits.length <= 4) return digits;
      if (digits.length <= 7) {
        return '${digits.substring(0, 4)} ${digits.substring(4)}';
      }
      if (digits.length <= 11) {
        return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
      }
      return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7, 11)} ${digits.substring(11)}';
    }

    // Iran Landline: 021 6675 4321 / 031 3123 4567
    if (digits.startsWith('0') && digits.length >= 3) {
      if (digits.length <= 3) return digits;
      if (digits.length <= 7) {
        return '${digits.substring(0, 3)} ${digits.substring(3)}';
      }
      if (digits.length <= 11) {
        return '${digits.substring(0, 3)} ${digits.substring(3, 7)} ${digits.substring(7)}';
      }
      return '${digits.substring(0, 3)} ${digits.substring(3, 7)} ${digits.substring(7, 11)} ${digits.substring(11)}';
    }

    // US standard 10-digit: 800 344 4539
    if (digits.length == 10) {
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    }

    return _chunkRest('', digits).trim();
  }

  static String _chunkRest(String prefix, String rest) {
    if (rest.isEmpty) return prefix;
    final buffer = StringBuffer(prefix.isEmpty ? '' : '$prefix ');

    if (rest.length <= 4) {
      buffer.write(rest);
      return buffer.toString();
    }

    if (rest.length <= 8) {
      final mid = (rest.length / 2).ceil();
      buffer.write('${rest.substring(0, mid)} ${rest.substring(mid)}');
      return buffer.toString();
    }

    int index = 0;
    while (index < rest.length) {
      final remaining = rest.length - index;
      final chunkSize = (remaining == 4 || remaining == 2)
          ? 2
          : (remaining > 4 ? 3 : remaining);
      if (index > 0) buffer.write(' ');
      buffer.write(rest.substring(index, index + chunkSize));
      index += chunkSize;
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String textToFormat = newValue.text;

    // Handle backspace over a formatting space smoothly
    if (oldValue.text.length == newValue.text.length + 1 &&
        oldValue.selection.isCollapsed &&
        oldValue.selection.start > 0 &&
        oldValue.text[oldValue.selection.start - 1] == ' ') {
      final cutIndex = oldValue.selection.start - 1;
      textToFormat = oldValue.text.substring(0, cutIndex - 1) +
          oldValue.text.substring(cutIndex);
    }

    final formatted = format(textToFormat);

    // Compute cursor position
    final textBeforeCursor = textToFormat.substring(
      0,
      newValue.selection.end.clamp(0, textToFormat.length),
    );
    final nonSpaceCharsBeforeCursor =
        textBeforeCursor.replaceAll(' ', '').length;

    int newCursorIndex = 0;
    int nonSpaceCount = 0;

    for (int i = 0; i < formatted.length; i++) {
      if (nonSpaceCount >= nonSpaceCharsBeforeCursor) {
        break;
      }
      if (formatted[i] != ' ') {
        nonSpaceCount++;
      }
      newCursorIndex = i + 1;
    }

    newCursorIndex = newCursorIndex.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorIndex),
    );
  }
}
