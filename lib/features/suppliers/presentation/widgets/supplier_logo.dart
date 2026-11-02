import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/theme/theme_provider.dart';

/// Helper to safely extract a clean domain from a website URL.
String? extractWebsiteDomain(String? rawUrl) {
  if (rawUrl == null) return null;
  var cleaned = rawUrl.trim();
  if (cleaned.isEmpty) return null;

  if (!cleaned.startsWith('http://') && !cleaned.startsWith('https://')) {
    cleaned = 'https://$cleaned';
  }

  try {
    final uri = Uri.parse(cleaned);
    String host = uri.host.trim().toLowerCase();
    if (host.isEmpty) {
      final withoutScheme = cleaned.replaceFirst(RegExp(r'^https?:\/\/'), '');
      host = withoutScheme
          .split('/')[0]
          .split('?')[0]
          .split('#')[0]
          .trim()
          .toLowerCase();
    }
    if (host.startsWith('www.')) {
      host = host.substring(4);
    }
    return host.isNotEmpty ? host : null;
  } catch (_) {
    return null;
  }
}

/// Offline-first cache manager for supplier and vendor logos.
/// Caches favicons both in-memory and on persistent disk to prevent
/// loading interruptions or blank logos on slow or offline networks.
class VendorLogoCache {
  static final Map<String, Uint8List> _memoryCache = {};
  static Directory? _cacheDir;

  static Future<File> _getCacheFile(String domain) async {
    if (_cacheDir == null) {
      final appDir = await getApplicationDocumentsDirectory();
      _cacheDir = Directory('${appDir.path}/vendor_logos');
      if (!await _cacheDir!.exists()) {
        await _cacheDir!.create(recursive: true);
      }
    }
    final safeName = domain.replaceAll(RegExp(r'[^a-zA-Z0-9_\-\.]'), '_');
    return File('${_cacheDir!.path}/$safeName.png');
  }

  /// Retrieves the logo bytes from memory or disk, or fetches over network if not cached yet.
  static Future<Uint8List?> getLogoBytes(String domain) async {
    // 1. Memory Cache
    if (_memoryCache.containsKey(domain)) {
      return _memoryCache[domain];
    }

    // 2. Persistent Disk Cache
    try {
      final file = await _getCacheFile(domain);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        if (bytes.isNotEmpty) {
          _memoryCache[domain] = bytes;
          return bytes;
        }
      }
    } catch (_) {}

    // 3. Network Fetch
    try {
      final logoUrl =
          'https://www.google.com/s2/favicons?domain=$domain&sz=128';
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 6);
      final request = await client.getUrl(Uri.parse(logoUrl));
      final response = await request.close();
      if (response.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        if (bytes.isNotEmpty) {
          _memoryCache[domain] = bytes;
          try {
            final file = await _getCacheFile(domain);
            await file.writeAsBytes(bytes);
          } catch (_) {}
          return bytes;
        }
      }
    } catch (_) {}

    return null;
  }
}

/// Renders a dynamic supplier/vendor website logo (favicon) with persistent offline caching
/// and graceful fallback to a storefront icon.
class SupplierLogo extends StatelessWidget {
  final String? website;
  final String? supplierName;
  final double size;
  final ThemeProvider theme;

  const SupplierLogo({
    super.key,
    required this.website,
    this.supplierName,
    this.size = 40,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final domain = extractWebsiteDomain(website);

    final Widget fallbackIcon = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.activeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.borderColor.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.storefront_rounded,
        color: theme.activeColor,
        size: size * 0.5,
      ),
    );

    if (domain == null) {
      return fallbackIcon;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.borderColor.withValues(alpha: 0.7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.isDark ? 0.3 : 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(5),
      child: FutureBuilder<Uint8List?>(
        future: VendorLogoCache.getLogoBytes(domain),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: size * 0.35,
                height: size * 0.35,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: theme.activeColor,
                ),
              ),
            );
          }

          final bytes = snapshot.data;
          if (bytes != null && bytes.isNotEmpty) {
            return Image.memory(
              bytes,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => fallbackIcon,
            );
          }

          return fallbackIcon;
        },
      ),
    );
  }
}
