/// QR payload generator and parser for PartPouch
enum QrTargetType { component, location, unknown }

class QrPayload {
  final QrTargetType type;
  final String id;
  final String raw;

  const QrPayload({required this.type, required this.id, required this.raw});

  static String generateComponentPayload(String componentId) {
    return 'partpouch://component/$componentId';
  }

  static String generateLocationPayload(String locationId) {
    return 'partpouch://location/$locationId';
  }

  static QrPayload parse(String raw) {
    final trimmed = raw.trim();
    final uri = Uri.tryParse(trimmed);

    if (uri != null && uri.scheme == 'partpouch') {
      final host = uri.host.toLowerCase();
      final pathSegments = uri.pathSegments;

      if (host == 'component' && pathSegments.isNotEmpty) {
        return QrPayload(
          type: QrTargetType.component,
          id: pathSegments.first,
          raw: trimmed,
        );
      }
      if (host == 'location' && pathSegments.isNotEmpty) {
        return QrPayload(
          type: QrTargetType.location,
          id: pathSegments.first,
          raw: trimmed,
        );
      }
      if (uri.pathSegments.isNotEmpty) {
        final firstSegment = uri.pathSegments.first.toLowerCase();
        if (firstSegment == 'component' && uri.pathSegments.length > 1) {
          return QrPayload(
            type: QrTargetType.component,
            id: uri.pathSegments[1],
            raw: trimmed,
          );
        }
        if (firstSegment == 'location' && uri.pathSegments.length > 1) {
          return QrPayload(
            type: QrTargetType.location,
            id: uri.pathSegments[1],
            raw: trimmed,
          );
        }
      }
    }

    // Direct UUID or SKU fallback
    return QrPayload(type: QrTargetType.unknown, id: trimmed, raw: trimmed);
  }
}
