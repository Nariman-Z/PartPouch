import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class PpTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int minLines;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  const PpTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines = 1,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.subTextColor,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          minLines: minLines,
          readOnly: readOnly,
          focusNode: focusNode,
          autofocus: autofocus,
          style: theme.textStyle(
            fontSize: 14,
            color: theme.textColor,
          ),
          cursorColor: theme.activeColor,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
