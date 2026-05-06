import 'package:uuid/uuid.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final int minThreshold;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.minThreshold,
    required this.updatedAt,
  });

  Product copyWith({
    String? name,
    String? category,
    int? quantity,
    int? minThreshold,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      minThreshold: minThreshold ?? this.minThreshold,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Product.create({
    required String name,
    required String category,
    required int quantity,
    required int minThreshold,
  }) {
    return Product(
      id: const Uuid().v4(),
      name: name,
      category: category,
      quantity: quantity,
      minThreshold: minThreshold,
      updatedAt: DateTime.now(),
    );
  }
}

enum StockLogType { stockIn, stockOut }

class StockLog {
  final String id;
  final String productId;
  final String productName;
  final StockLogType type;
  final int quantity;
  final DateTime timestamp;

  StockLog({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.timestamp,
  });

  factory StockLog.create({
    required String productId,
    required String productName,
    required StockLogType type,
    required int quantity,
  }) {
    return StockLog(
      id: const Uuid().v4(),
      productId: productId,
      productName: productName,
      type: type,
      quantity: quantity,
      timestamp: DateTime.now(),
    );
  }
}
