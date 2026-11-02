import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/partpouch_logo_title.dart';
import '../../../../core/widgets/pp_text_field.dart';
import '../../data/export_import_service.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import 'appearance_screen.dart';

/// Settings & Preferences screen redesigned with Ambinet UI/UX design rules.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isExporting = false;
  bool _isImporting = false;
  bool _isResetting = false;

  Future<void> _exportData() async {
    final theme = ThemeProvider();
    setState(() => _isExporting = true);
    try {
      final jsonString =
          await ref.read(exportImportServiceProvider).exportToJson();

      await SharePlus.instance.share(
        ShareParams(
          text: jsonString,
          subject:
              'PartPouch_Backup_${DateTime.now().toIso8601String().substring(0, 10)}.json',
        ),
      );

      if (mounted) {
        AppSnackBar.show(
          context,
          message: theme.translate('backup_export_success'),
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: e.toString(),
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _importData() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (files.isEmpty) return;

    final file = files.first;
    try {
      final content = await file.xFile.readAsString();
      _confirmAndRestore(content);
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Error reading file: $e',
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _pasteAndRestoreFromClipboard() async {
    final theme = ThemeProvider();
    final clipData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipData?.text?.trim() ?? '';
    if (text.isEmpty) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? 'کلیپ‌بورد خالی است یا متن معتبری یافت نشد.'
              : 'Clipboard is empty or contains no text.',
          type: SnackBarType.info,
        );
      }
      return;
    }

    try {
      final parsed = jsonDecode(text);
      if (parsed is! Map ||
          parsed['app'] != 'PartPouch' ||
          parsed['version'] == null) {
        if (mounted) {
          AppSnackBar.show(
            context,
            message: theme.currentLanguage == 'Persian'
                ? 'متن کلیپ‌بورد نسخه پشتیبان معتبر پارت‌پوچ نیست.'
                : 'Clipboard content is not a valid PartPouch backup.',
            type: SnackBarType.error,
          );
        }
        return;
      }
    } catch (_) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? 'محتوای کلیپ‌بورد قالب JSON معتبر ندارد.'
              : 'Clipboard content is not valid JSON.',
          type: SnackBarType.error,
        );
      }
      return;
    }

    await _confirmAndRestore(text);
  }

  Future<void> _confirmAndRestore(String jsonContent) async {
    final theme = ThemeProvider();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: theme.borderColor),
        ),
        title: Text(
          theme.currentLanguage == 'Persian'
              ? 'بازیابی از فایل پشتیبان؟'
              : 'Restore from Backup?',
          style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(
          theme.currentLanguage == 'Persian'
              ? 'با انجام این عملیات، تمامی اطلاعات موجود بازنویسی شده و پایگاه داده از روی نسخه پشتیبان بازگردانی می‌شود.'
              : 'This will overwrite existing inventory and restore the database from the backup file.',
          style: theme.textStyle(fontSize: 13, color: theme.subTextColor),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  theme.translate('cancel'),
                  style: theme.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.subTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    theme.currentLanguage == 'Persian'
                        ? 'تأیید و بازیابی'
                        : 'Confirm Restore',
                    style: theme.textStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isImporting = true);
    try {
      await ref.read(exportImportServiceProvider).importFromJson(jsonContent);
      if (mounted) {
        AppSnackBar.show(
          context,
          message: theme.translate('database_restored_success'),
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Import failed: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  void _showCurrencyConfigDialog() {
    final theme = ThemeProvider();
    String selectedCurrency = theme.currency;
    final rateController = TextEditingController(
      text: theme.usdToTomanRate > 0
          ? theme.usdToTomanRate.round().toString()
          : '',
    );

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isToman = selectedCurrency == 'TOMAN';

          double? parseRate() {
            String raw = rateController.text.trim().toLowerCase();
            if (raw.isEmpty) return null;
            const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
            const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
            for (int i = 0; i < 10; i++) {
              raw = raw.replaceAll(persian[i], english[i]);
            }
            raw = raw.replaceAll(',', '').replaceAll(' ', '');
            if (raw.endsWith('k')) {
              final numPart =
                  double.tryParse(raw.substring(0, raw.length - 1)) ?? 0;
              return numPart * 1000;
            }
            return double.tryParse(raw);
          }

          final currentRate = parseRate();

          return AlertDialog(
            backgroundColor: theme.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: theme.borderColor),
            ),
            title: Text(
              theme.translate('currency_dialog_title'),
              style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.translate('currency_desc'),
                    style: theme.textStyle(
                      fontSize: 13,
                      color: theme.subTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Currency Selection Tabs
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() => selectedCurrency = 'USD');
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isToman
                                  ? theme.activeColor
                                  : (theme.isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : Colors.black.withValues(alpha: 0.04)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'USD (\$)',
                              textAlign: TextAlign.center,
                              style: theme.textStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    !isToman ? Colors.white : theme.textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() => selectedCurrency = 'TOMAN');
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isToman
                                  ? theme.activeColor
                                  : (theme.isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : Colors.black.withValues(alpha: 0.04)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              theme.isRtl ? 'تومان (Toman)' : 'Toman (تومان)',
                              textAlign: TextAlign.center,
                              style: theme.textStyle(
                                fontWeight: FontWeight.bold,
                                color: isToman ? Colors.white : theme.textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (isToman) ...[
                    const SizedBox(height: 20),
                    Text(
                      theme.translate('dollar_rate_label'),
                      style: theme.textStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PpTextField(
                      controller: rateController,
                      hint: theme.translate('dollar_rate_hint'),
                      keyboardType: TextInputType.text,
                      onChanged: (_) => setDialogState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.isDark
                            ? const Color(0xFF0F1A24)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: theme.borderColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            theme.translate('rate_preview'),
                            style: theme.textStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.subTextColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$1.00 USD =',
                                style: theme.textStyle(
                                  fontSize: 13,
                                  color: theme.subTextColor,
                                ),
                              ),
                              Text(
                                currentRate != null && currentRate > 0
                                    ? (theme.isRtl
                                        ? '${theme.formatNumber(NumberFormat('#,##0').format(currentRate.round()))} تومان'
                                        : '${NumberFormat('#,##0').format(currentRate.round())} Toman')
                                    : (theme.isRtl ? 'ثبت نشده' : 'Not set'),
                                style: theme.textStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: theme.activeColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$10.00 USD =',
                                style: theme.textStyle(
                                  fontSize: 13,
                                  color: theme.subTextColor,
                                ),
                              ),
                              Text(
                                currentRate != null && currentRate > 0
                                    ? (theme.isRtl
                                        ? '${theme.formatNumber(NumberFormat('#,##0').format((currentRate * 10).round()))} تومان'
                                        : '${NumberFormat('#,##0').format((currentRate * 10).round())} Toman')
                                    : (theme.isRtl ? 'ثبت نشده' : 'Not set'),
                                style: theme.textStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: theme.activeColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: Text(
                      theme.translate('cancel'),
                      style: theme.textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.subTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.activeColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(dialogCtx);
                        await theme.setCurrency(selectedCurrency);
                        if (selectedCurrency == 'TOMAN') {
                          final rate = parseRate();
                          await theme.setUsdToTomanRate(rate);
                        }
                        if (mounted) {
                          AppSnackBar.show(
                            this.context,
                            message: theme.translate('currency_updated'),
                            type: SnackBarType.success,
                          );
                        }
                      },
                      child: Text(
                        theme.translate('save'),
                        style: theme.textStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _resetAllData() async {
    final theme = ThemeProvider();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: theme.borderColor),
        ),
        title: Text(
          theme.translate('reset_all_data'),
          style: theme.textStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        content: Text(
          theme.currentLanguage == 'Persian'
              ? 'هشدار جدی: این عملیات غیرقابل بازگشت است. تمامی قطعات، قفسه‌ها، سوابق انبار و سفارش‌ها به‌طور کامل پاک خواهند شد.'
              : 'DANGER: This action cannot be undone. All components, locations, stock balances, movements, and purchase orders will be erased.',
          style: theme.textStyle(fontSize: 13, color: theme.subTextColor),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  theme.translate('cancel'),
                  style: theme.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.subTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    theme.currentLanguage == 'Persian'
                        ? 'حذف کامل اطلاعات'
                        : 'Erase Everything',
                    style: theme.textStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isResetting = true);
    try {
      await ref.read(exportImportServiceProvider).resetAllData();
      if (mounted) {
        AppSnackBar.show(
          context,
          message: theme.translate('all_data_erased_success'),
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: e.toString(),
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isResetting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.primaryColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              theme.translate('settings_title'),
              style: theme.textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // Section: General Preferences
              SettingsSection(title: theme.translate('preferences')),
              SettingsCard(
                children: [
                  SettingsTile(
                    icon: Icons.palette_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                    title: theme.translate('appearance'),
                    subtitle: theme.translate('appearance_desc'),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: theme.subTextColor.withValues(alpha: 0.5),
                      size: 22,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AppearanceScreen(),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.currency_exchange_rounded,
                    iconColor: AppColors.success,
                    title: theme.translate('currency'),
                    subtitle: theme.isToman
                        ? (theme.usdToTomanRate > 0
                            ? (theme.isRtl
                                ? 'نرخ: ۱ دلار = ${theme.formatNumber(NumberFormat('#,##0').format(theme.usdToTomanRate.round()))} تومان'
                                : 'Rate: 1 USD = ${NumberFormat('#,##0').format(theme.usdToTomanRate.round())} Toman')
                            : (theme.isRtl
                                ? 'نرخ دلار تعیین نشده است'
                                : 'No exchange rate set'))
                        : (theme.isRtl
                            ? 'محاسبه استاندارد دلاری (\$)'
                            : 'Standard dollar valuation (\$)'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          theme.isToman
                              ? (theme.isRtl ? 'تومان' : 'Toman')
                              : 'USD (\$)',
                          style: theme.textStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: theme.activeColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.subTextColor.withValues(alpha: 0.5),
                          size: 20,
                        ),
                      ],
                    ),
                    onTap: _showCurrencyConfigDialog,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section: Backup & Restore
              SettingsSection(
                title: theme.translate('backup_and_portability'),
              ),
              SettingsCard(
                children: [
                  SettingsTile(
                    icon: Icons.upload_file_rounded,
                    iconColor: const Color(0xFF0EA5E9),
                    title: theme.translate('export_json_backup'),
                    subtitle: theme.translate('export_backup_desc'),
                    onTap: _isExporting ? null : _exportData,
                  ),
                  SettingsTile(
                    icon: Icons.file_open_outlined,
                    iconColor: AppColors.secondary,
                    title: theme.translate('import_backup_file'),
                    subtitle: theme.translate('import_backup_desc'),
                    onTap: _isImporting ? null : _importData,
                  ),
                  SettingsTile(
                    icon: Icons.content_paste_rounded,
                    iconColor: AppColors.warning,
                    title: theme.translate('paste_backup_text'),
                    subtitle: theme.translate('paste_backup_desc'),
                    onTap: _isImporting ? null : _pasteAndRestoreFromClipboard,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section: Help & Walkthrough
              SettingsSection(title: theme.translate('help_and_onboarding')),
              SettingsCard(
                children: [
                  SettingsTile(
                    icon: Icons.lightbulb_outline_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: theme.translate('replay_onboarding'),
                    subtitle: theme.translate('replay_onboarding_desc'),
                    onTap: () => context.push('/onboarding'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section: Danger Zone
              SettingsSection(title: theme.translate('danger_zone')),
              SettingsCard(
                children: [
                  SettingsTile(
                    icon: Icons.delete_forever_rounded,
                    iconColor: AppColors.error,
                    iconBgColor: AppColors.error.withValues(alpha: 0.12),
                    title: theme.translate('reset_all_data'),
                    subtitle: theme.translate('reset_all_desc'),
                    onTap: _isResetting ? null : _resetAllData,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // About Section Footer
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/icons/app_icon_512.webp',
                        width: 56,
                        height: 56,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const PartPouchBrandTitle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version ${AppConstants.appVersion} • ${theme.translate('app_version_tag')}',
                      style: theme.textStyle(
                        fontSize: 12,
                        color: theme.subTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      theme.translate('app_tagline'),
                      style: theme.textStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.subTextColor.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
