import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_inventory_app/models/inventory_models.dart';

// Product State Notifier
class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void addProduct(Product product) {
    state = [...state, product];
  }

  void updateProduct(Product updatedProduct) {
    state = [
      for (final p in state)
        if (p.id == updatedProduct.id) updatedProduct else p
    ];
  }

  void deleteProduct(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  void updateStock(String productId, int change, StockLogType type) {
    state = [
      for (final p in state)
        if (p.id == productId)
          p.copyWith(
            quantity: type == StockLogType.stockIn ? p.quantity + change : p.quantity - change,
            updatedAt: DateTime.now(),
          )
        else
          p
    ];
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  return ProductNotifier();
});

// Stock Log State Notifier
class StockLogNotifier extends StateNotifier<List<StockLog>> {
  StockLogNotifier() : super([]);

  void addLog(StockLog log) {
    state = [log, ...state]; // Newest first
  }
}

final stockLogProvider = StateNotifierProvider<StockLogNotifier, List<StockLog>>((ref) {
  return StockLogNotifier();
});

// Derived Providers
final lowStockProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productProvider);
  return products.where((p) => p.quantity <= p.minThreshold).toList();
});

final criticalStockProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productProvider);
  return products.where((p) => p.quantity == 0).toList();
});
