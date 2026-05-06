import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_inventory_app/models/inventory_models.dart';
import 'package:smart_inventory_app/services/database_service.dart';
import 'package:smart_inventory_app/services/sync_service.dart';

final syncServiceProvider = Provider((ref) => SyncService());

// Product State Notifier
class ProductNotifier extends StateNotifier<List<Product>> {
  final SyncService _syncService;

  ProductNotifier(this._syncService) : super(DatabaseService.loadProducts()) {
    // Optional: Initial sync on startup
    _initialSync();
  }

  Future<void> _initialSync() async {
    final cloudProducts = await _syncService.fetchFromCloud();
    if (cloudProducts.isNotEmpty) {
      state = cloudProducts;
      DatabaseService.saveProducts(state);
    }
  }

  void addProduct(Product product) {
    state = [...state, product];
    DatabaseService.saveProducts(state);
    _syncService.syncLocalToCloud(state);
  }

  void updateProduct(Product updatedProduct) {
    state = [
      for (final p in state)
        if (p.id == updatedProduct.id) updatedProduct else p
    ];
    DatabaseService.saveProducts(state);
    _syncService.syncLocalToCloud(state);
  }

  void deleteProduct(String id) {
    state = state.where((p) => p.id != id).toList();
    DatabaseService.saveProducts(state);
    _syncService.syncLocalToCloud(state);
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
    DatabaseService.saveProducts(state);
    _syncService.syncLocalToCloud(state);
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  return ProductNotifier(ref.watch(syncServiceProvider));
});

// Stock Log State Notifier
class StockLogNotifier extends StateNotifier<List<StockLog>> {
  StockLogNotifier() : super(DatabaseService.loadLogs());

  void addLog(StockLog log) {
    state = [log, ...state]; // Newest first
    DatabaseService.saveLogs(state);
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
