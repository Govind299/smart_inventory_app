import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_inventory_app/models/inventory_models.dart';

class SyncService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Initialize Firestore Persistence for Web/Mobile
  Future<void> init() async {
    try {
      if (kIsWeb) {
        // Enable persistence for Web (Chrome)
        await _db.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
      } else {
        // Enable for Mobile
        _db.settings = const Settings(persistenceEnabled: true);
      }
      debugPrint('Firestore Persistence Enabled');
    } catch (e) {
      debugPrint('Error enabling Firestore persistence: $e');
    }
  }

  // Sync all local products to Firestore
  // Note: Because we enabled persistence, Firestore will automatically queue these 
  // even if offline and sync them later when the connection returns!
  Future<void> syncLocalToCloud(List<Product> localProducts) async {
    try {
      // Use a batch to sync everything efficiently
      final batch = _db.batch();
      for (var product in localProducts) {
        final docRef = _db.collection('products').doc(product.id);
        batch.set(docRef, _productToMap(product));
      }
      await batch.commit();
      debugPrint('Cloud sync operation completed (or queued if offline).');
    } catch (e) {
      debugPrint('Sync Error: $e');
    }
  }

  Future<List<Product>> fetchFromCloud() async {
    try {
      // Get from server first, fallback to cache if offline
      final snapshot = await _db.collection('products').get(const GetOptions(source: Source.serverAndCache));
      return snapshot.docs.map((doc) => _mapToProduct(doc.data())).toList();
    } catch (e) {
      debugPrint('Fetch Error: $e');
      return [];
    }
  }

  // Helper Mappers
  Map<String, dynamic> _productToMap(Product p) => {
    'id': p.id,
    'name': p.name,
    'category': p.category,
    'quantity': p.quantity,
    'minThreshold': p.minThreshold,
    'updatedAt': p.updatedAt.toIso8601String(),
  };

  Product _mapToProduct(Map<String, dynamic> map) => Product(
    id: map['id'],
    name: map['name'],
    category: map['category'],
    quantity: map['quantity'],
    minThreshold: map['minThreshold'],
    updatedAt: DateTime.parse(map['updatedAt']),
  );
}
