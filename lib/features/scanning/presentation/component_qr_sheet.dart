import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/qr_payload_parser.dart';

class ComponentQrSheet extends StatelessWidget {
  final Component component;

  const ComponentQrSheet({super.key, required this.component});

  static void show(BuildContext context, Component component) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ComponentQrSheet(component: component),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final payload = QrPayload.generateComponentPayload(component.id);

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: theme.secondaryColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: theme.borderColor, width: 1),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    theme.translate('component_qr_label'),
                    style: theme.textStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.subTextColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Physical Label Preview Card (White sticker)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    QrImageView(
                      data: payload,
                      version: QrVersions.auto,
                      size: 180,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      component.name,
                      style: const TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (component.internalSku != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'SKU: ${component.internalSku}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                    if (component.manufacturerPartNumber != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'MPN: ${component.manufacturerPartNumber}',
                        style: const TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 12,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      payload,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Color(0xFF888888),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.activeColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.share_rounded, size: 20),
                  label: Text(
                    theme.translate('share_payload'),
                    style: theme.textStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text:
                            'PartPouch Component Label:\n${component.name}\n$payload',
                        subject: 'PartPouch Label - ${component.name}',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
