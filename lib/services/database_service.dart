import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_inventory_app/models/inventory_models.dart';

class DatabaseService {
  static const String productBoxName = 'products_box';
  static const String logBoxName = 'logs_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(productBoxName);
    await Hive.openBox(logBoxName);
  }

  // --- Products ---
  static List<Product> loadProducts() {
    final box = Hive.box(productBoxName);
    final List<dynamic> rawData = box.get('products', defaultValue: []);
    return rawData.map((e) => _mapToProduct(jsonDecode(e))).toList();
  }

  static Future<void> saveProducts(List<Product> products) async {
    final box = Hive.box(productBoxName);
    final List<String> jsonData = products.map((e) => jsonEncode(_productToMap(e))).toList();
    await box.put('products', jsonData);
  }

  // --- Logs ---
  static List<StockLog> loadLogs() {
    final box = Hive.box(logBoxName);
    final List<dynamic> rawData = box.get('logs', defaultValue: []);
    return rawData.map((e) => _mapToLog(jsonDecode(e))).toList();
  }

  static Future<void> saveLogs(List<StockLog> logs) async {
    final box = Hive.box(logBoxName);
    final List<String> jsonData = logs.map((e) => jsonEncode(_logToMap(e))).toList();
    await box.put('logs', jsonData);
  }

  // --- Helper Mappers (JSON) ---
  static Map<String, dynamic> _productToMap(Product p) => {
    'id': p.id,
    'name': p.name,
    'category': p.category,
    'quantity': p.quantity,
    'minThreshold': p.minThreshold,
    'updatedAt': p.updatedAt.toIso8601String(),
  };

  static Product _mapToProduct(Map<String, dynamic> map) => Product(
    id: map['id'],
    name: map['name'],
    category: map['category'],
    quantity: map['quantity'],
    minThreshold: map['minThreshold'],
    updatedAt: DateTime.parse(map['updatedAt']),
  );

  static Map<String, dynamic> _logToMap(StockLog l) => {
    'id': l.id,
    'productId': l.productId,
    'productName': l.productName,
    'type': l.type.name,
    'quantity': l.quantity,
    'timestamp': l.timestamp.toIso8601String(),
  };

  static StockLog _mapToLog(Map<String, dynamic> map) => StockLog(
    id: map['id'],
    productId: map['productId'],
    productName: map['productName'],
    type: StockLogType.values.byName(map['type']),
    quantity: map['quantity'],
    timestamp: DateTime.parse(map['timestamp']),
  );
}
