import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/database.dart';
import '../../../core/formatting/phone_number_formatter.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../data/suppliers_repository.dart';
import 'widgets/supplier_logo.dart';

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});

  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditSupplierDialog([Supplier? existing]) {
    showDialog(
      context: context,
      builder: (context) => _AddEditSupplierDialog(supplier: existing),
    );
  }

  Future<void> _exportVendors() async {
    final theme = ThemeProvider();
    try {
      final jsonString =
          await ref.read(suppliersRepositoryProvider).exportSuppliersToJson();

      await SharePlus.instance.share(
        ShareParams(
          text: jsonString,
          subject:
              'PartPouch_Vendors_${DateTime.now().toIso8601String().substring(0, 10)}.json',
        ),
      );

      if (mounted) {
        AppSnackBar.show(
          context,
          message: theme.translate('vendors_exported_success'),
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Export failed: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _importVendorsFromFile() async {
    final theme = ThemeProvider();
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (files.isEmpty) return;

      final file = files.first;
      final content = await file.xFile.readAsString();
      final count = await ref
          .read(suppliersRepositoryProvider)
          .importSuppliersFromJson(content);

      if (mounted) {
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? '${theme.formatNumber(count)} تأمین‌کننده با موفقیت وارد شدند.'
              : '$count vendors imported successfully.',
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
    }
  }

  void _showPasteImportDialog() {
    final theme = ThemeProvider();
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: theme.borderColor),
        ),
        title: Text(
          theme.translate('paste_vendors_json'),
          style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              theme.currentLanguage == 'Persian'
                  ? 'متن JSON حاوی لیست تأمین‌کنندگان را در کادر زیر وارد کنید:'
                  : 'Paste the vendors JSON data in the box below:',
              style: theme.textStyle(fontSize: 13, color: theme.subTextColor),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              maxLines: 8,
              style: theme.textStyle(fontSize: 12, color: theme.textColor),
              decoration: InputDecoration(
                hintText:
                    '{\n  "suppliers": [\n    {"name": "Octopart", "website": "https://octopart.com/"}\n  ]\n}',
                hintStyle:
                    theme.textStyle(fontSize: 12, color: theme.subTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.borderColor),
                ),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  theme.translate('cancel'),
                  style: theme.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.subTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.activeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final text = textController.text.trim();
                  if (text.isEmpty) return;
                  Navigator.pop(context);
                  try {
                    final count = await ref
                        .read(suppliersRepositoryProvider)
                        .importSuppliersFromJson(text);
                    if (mounted) {
                      AppSnackBar.show(
                        context,
                        message: theme.currentLanguage == 'Persian'
                            ? '${theme.formatNumber(count)} تأمین‌کننده با موفقیت وارد شدند.'
                            : '$count vendors imported successfully.',
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
                  }
                },
                child: Text(
                  theme.translate('import_vendors'),
                  style: theme.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadDemoVendors() async {
    final theme = ThemeProvider();
    try {
      final count = await ref
          .read(suppliersRepositoryProvider)
          .seedDefaultSuppliers();

      if (mounted) {
        AppSnackBar.show(
          context,
          message: count > 0
              ? (theme.currentLanguage == 'Persian'
                  ? '${theme.formatNumber(count)} فروشگاه نمونه به لیست اضافه شد.'
                  : '$count demo vendors added to list.')
              : (theme.currentLanguage == 'Persian'
                  ? 'تمامی فروشگاه‌های نمونه از قبل در لیست وجود دارند.'
                  : 'All demo vendors are already in your list.'),
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Error: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    final suppliersStream = ref
        .watch(suppliersRepositoryProvider)
        .watchAllSuppliers(query: _searchQuery);

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
              theme.translate('suppliers_and_vendors'),
              style: theme.textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.save_rounded,
                  color: theme.activeColor,
                  size: 24,
                ),
                tooltip: theme.translate('import_export_vendors'),
                color: theme.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.borderColor),
                ),
                onSelected: (val) {
                  switch (val) {
                    case 'export':
                      _exportVendors();
                      break;
                    case 'import_file':
                      _importVendorsFromFile();
                      break;
                    case 'import_paste':
                      _showPasteImportDialog();
                      break;
                    case 'demo':
                      _loadDemoVendors();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'export',
                    child: Row(
                      children: [
                        Icon(
                          Icons.share_rounded,
                          size: 18,
                          color: theme.activeColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          theme.translate('export_vendors'),
                          style: theme.textStyle(
                            fontSize: 13,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'import_file',
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          size: 18,
                          color: theme.activeColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          theme.translate('import_from_file'),
                          style: theme.textStyle(
                            fontSize: 13,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'import_paste',
                    child: Row(
                      children: [
                        Icon(
                          Icons.content_paste_rounded,
                          size: 18,
                          color: theme.activeColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          theme.translate('paste_vendors_json'),
                          style: theme.textStyle(
                            fontSize: 13,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'demo',
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 18,
                          color: theme.activeColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          theme.translate('load_demo_vendors'),
                          style: theme.textStyle(
                            fontSize: 13,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Field
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.borderColor, width: 1),
                  ),
                  child: TextField(
                    controller: _searchController,
                    cursorColor: theme.activeColor,
                    style: theme.textStyle(fontSize: 14, color: theme.textColor),
                    decoration: InputDecoration(
                      hintText: theme.currentLanguage == 'Persian'
                          ? 'جستجوی نام فروشگاه، وب‌سایت یا ایمیل...'
                          : 'Search suppliers by name, website, email...',
                      hintStyle: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.subTextColor,
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: theme.subTextColor,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
              ),

              // Suppliers List
              Expanded(
                child: StreamBuilder<List<Supplier>>(
                  stream: suppliersStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: theme.activeColor),
                      );
                    }

                    final suppliers = snapshot.data ?? [];

                    if (suppliers.isEmpty) {
                      return PpEmptyState(
                        icon: Icons.storefront_outlined,
                        title: theme.translate('no_suppliers'),
                        message: theme.translate('suppliers_desc'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: suppliers.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final sup = suppliers[index];
                        return _SupplierCard(
                          supplier: sup,
                          theme: theme,
                          onTap: () => _showAddEditSupplierDialog(sup),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'suppliers_fab',
            backgroundColor: theme.activeColor,
            foregroundColor: Colors.white,
            tooltip: theme.translate('add_supplier'),
            onPressed: () => _showAddEditSupplierDialog(),
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }
}

class _SupplierCard extends StatelessWidget {
  final Supplier supplier;
  final ThemeProvider theme;
  final VoidCallback onTap;

  const _SupplierCard({
    required this.supplier,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PpCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      backgroundColor: theme.secondaryColor,
      borderColor: theme.borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SupplierLogo(
                website: supplier.website,
                supplierName: supplier.name,
                size: 40,
                theme: theme,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  supplier.name,
                  style: theme.textStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                  ),
                ),
              ),
              Icon(
                Icons.edit_outlined,
                size: 18,
                color: theme.subTextColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (supplier.email != null && supplier.email!.isNotEmpty) ...[
            InkWell(
              onTap: () {
                final uri = Uri.tryParse('mailto:${supplier.email!}');
                if (uri != null) launchUrl(uri);
              },
              borderRadius: BorderRadius.circular(4),
              child: Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 14,
                    color: theme.subTextColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    supplier.email!,
                    style: theme.textStyle(fontSize: 12, color: theme.subTextColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
          ],
          if (supplier.phone != null && supplier.phone!.isNotEmpty) ...[
            InkWell(
              onTap: () {
                final uri = Uri.tryParse('tel:${supplier.phone!}');
                if (uri != null) launchUrl(uri);
              },
              borderRadius: BorderRadius.circular(4),
              child: Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 14,
                    color: theme.subTextColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    theme.formatNumber(
                      PhoneNumberFormatter.format(supplier.phone!),
                    ),
                    style:
                        theme.textStyle(fontSize: 12, color: theme.subTextColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
          ],
          if (supplier.website != null && supplier.website!.isNotEmpty) ...[
            InkWell(
              onTap: () => _openBrowserUrl(context, supplier.website!),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.link_rounded, size: 14, color: theme.activeColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        supplier.website!,
                        style: theme.textStyle(
                          fontSize: 12,
                          color: theme.activeColor,
                        ).copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: theme.activeColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 13,
                      color: theme.activeColor.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (supplier.notes != null && supplier.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              supplier.notes!,
              style: theme.textStyle(
                fontSize: 12,
                color: theme.subTextColor,
              ),
              maxLines: 2,
            ),
          ],
        ],
      ),
    );
  }
}

class _AddEditSupplierDialog extends ConsumerStatefulWidget {
  final Supplier? supplier;

  const _AddEditSupplierDialog({this.supplier});

  @override
  ConsumerState<_AddEditSupplierDialog> createState() =>
      _AddEditSupplierDialogState();
}

class _AddEditSupplierDialogState
    extends ConsumerState<_AddEditSupplierDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _websiteController;
  late final TextEditingController _notesController;
  bool _isLoading = false;

  bool get isEdit => widget.supplier != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier?.name ?? '');
    _emailController = TextEditingController(
      text: widget.supplier?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: PhoneNumberFormatter.format(widget.supplier?.phone),
    );
    _websiteController = TextEditingController(
      text: widget.supplier?.website ?? '',
    );
    _notesController = TextEditingController(
      text: widget.supplier?.notes ?? '',
    );
    _websiteController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final theme = ThemeProvider();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final rawPhone = _phoneController.text.trim();
      final formattedPhone =
          rawPhone.isEmpty ? null : PhoneNumberFormatter.format(rawPhone);

      if (isEdit) {
        await ref
            .read(suppliersRepositoryProvider)
            .updateSupplier(
              id: widget.supplier!.id,
              name: _nameController.text.trim(),
              website: _websiteController.text.trim().isEmpty
                  ? null
                  : _websiteController.text.trim(),
              email: _emailController.text.trim().isEmpty
                  ? null
                  : _emailController.text.trim(),
              phone: formattedPhone,
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            );
      } else {
        await ref
            .read(suppliersRepositoryProvider)
            .createSupplier(
              name: _nameController.text.trim(),
              website: _websiteController.text.trim().isEmpty
                  ? null
                  : _websiteController.text.trim(),
              email: _emailController.text.trim().isEmpty
                  ? null
                  : _emailController.text.trim(),
              phone: formattedPhone,
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            );
      }

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: isEdit
              ? (theme.currentLanguage == 'Persian' ? 'اطلاعات تأمین‌کننده ذخیره شد.' : 'Supplier updated.')
              : (theme.currentLanguage == 'Persian' ? 'تأمین‌کننده جدید ایجاد شد.' : 'Supplier created.'),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteSupplier() async {
    final theme = ThemeProvider();
    final supplierName = widget.supplier?.name ?? '';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: theme.borderColor),
        ),
        title: Text(
          theme.translate('delete_supplier'),
          style: theme.textStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        content: Text(
          theme
              .translate('delete_supplier_confirm')
              .replaceAll('{name}', supplierName),
          style: theme.textStyle(fontSize: 13, color: theme.subTextColor),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  theme.translate('cancel'),
                  style: theme.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.subTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  theme.translate('delete'),
                  style: theme.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(suppliersRepositoryProvider)
          .deleteSupplier(widget.supplier!.id);

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: theme.translate('supplier_deleted_success'),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    return AlertDialog(
      backgroundColor: theme.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: theme.borderColor),
      ),
      title: Row(
        children: [
          SupplierLogo(
            website: _websiteController.text.trim().isEmpty
                ? null
                : _websiteController.text.trim(),
            supplierName: _nameController.text,
            size: 32,
            theme: theme,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isEdit
                  ? theme.translate('edit_supplier')
                  : theme.translate('add_supplier'),
              style: theme.textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PpTextField(
                controller: _nameController,
                label: '${theme.translate('supplier_name')} *',
                hint: 'e.g. Mouser Electronics, Digi-Key',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return theme.translate('required_field');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              PpTextField(
                controller: _emailController,
                label: theme.translate('email'),
                hint: 'sales@distributor.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              PpTextField(
                controller: _phoneController,
                label: theme.translate('phone'),
                hint: '+1 800 123 4567',
                keyboardType: TextInputType.phone,
                inputFormatters: const [PhoneNumberFormatter()],
              ),
              const SizedBox(height: 12),
              PpTextField(
                controller: _websiteController,
                label: theme.translate('website'),
                hint: 'https://...',
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 12),
              PpTextField(
                controller: _notesController,
                label: theme.translate('notes'),
                hint: theme.currentLanguage == 'Persian'
                    ? 'شماره حساب، شرایط ارسال و حداقل مبلغ سفارش...'
                    : 'Account #, shipping terms, minimum order...',
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            if (isEdit)
              TextButton.icon(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: AppColors.error,
                ),
                label: Text(
                  theme.translate('delete'),
                  style: theme.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                onPressed: _isLoading ? null : _deleteSupplier,
              ),
            if (!isEdit)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  theme.translate('cancel'),
                  style: theme.textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.subTextColor,
                  ),
                ),
              ),
            if (!isEdit) const SizedBox(width: 12),
            if (isEdit) const SizedBox(width: 8),
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
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isEdit ? theme.translate('save') : theme.translate('add'),
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
  }
}

Future<void> _openBrowserUrl(BuildContext context, String urlString) async {
  String formatted = urlString.trim();
  if (formatted.isEmpty) return;
  if (!formatted.startsWith('http://') && !formatted.startsWith('https://')) {
    formatted = 'https://$formatted';
  }
  final uri = Uri.tryParse(formatted);
  if (uri != null) {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        AppSnackBar.show(
          context,
          message: 'Could not open link: $formatted',
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.show(
          context,
          message: 'Error opening browser: $e',
          type: SnackBarType.error,
        );
      }
    }
  }
}
