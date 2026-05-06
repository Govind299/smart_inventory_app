import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:smart_inventory_app/core/theme.dart';
import 'package:smart_inventory_app/models/inventory_models.dart';
import 'package:smart_inventory_app/services/inventory_provider.dart';

class ProductManagementScreen extends ConsumerWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(LucideIcons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          Expanded(
            child: products.isEmpty 
              ? const Center(child: Text('No products yet. Click + to add.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (context, index) => _ProductTile(product: products[index]),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductDialog(context, ref),
        label: const Text('New Product'),
        icon: const Icon(LucideIcons.plus),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final qtyController = TextEditingController();
    final thresholdController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add New Product', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildField('Product Name', LucideIcons.package, nameController),
            _buildField('Category', LucideIcons.tag, categoryController),
            Row(
              children: [
                Expanded(child: _buildField('Initial Qty', LucideIcons.hash, qtyController, keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _buildField('Min Threshold', LucideIcons.alertTriangle, thresholdController, keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty || categoryController.text.isEmpty || qtyController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
                    return;
                  }
                  final product = Product.create(
                    name: nameController.text,
                    category: categoryController.text,
                    quantity: int.tryParse(qtyController.text) ?? 0,
                    minThreshold: int.tryParse(thresholdController.text) ?? 5,
                  );
                  ref.read(productProvider.notifier).addProduct(product);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Product'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, IconData icon, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _ProductTile extends ConsumerWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: const Icon(LucideIcons.package, color: AppTheme.primaryColor, size: 20),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${product.category} • Qty: ${product.quantity}'),
        trailing: IconButton(
          icon: const Icon(LucideIcons.trash2, color: AppTheme.dangerColor, size: 20),
          onPressed: () => ref.read(productProvider.notifier).deleteProduct(product.id),
        ),
      ),
    );
  }
}
