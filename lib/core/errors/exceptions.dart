/// Custom domain exceptions for PartPouch
class PartPouchException implements Exception {
  final String message;
  const PartPouchException(this.message);

  @override
  String toString() => message;
}

class InsufficientStockException extends PartPouchException {
  final int available;
  final int requested;

  const InsufficientStockException({
    required this.available,
    required this.requested,
    String? message,
  }) : super(
         message ??
             'Insufficient stock: $available available, but $requested requested.',
       );
}

class InvalidLocationHierarchyException extends PartPouchException {
  const InvalidLocationHierarchyException(super.message);
}

class LocationNotEmptyException extends PartPouchException {
  final int unitsRemaining;
  const LocationNotEmptyException(this.unitsRemaining)
    : super(
        'Cannot archive location with $unitsRemaining units of stock remaining. Please transfer stock first.',
      );
}

class OverReceiptException extends PartPouchException {
  const OverReceiptException(super.message);
}
