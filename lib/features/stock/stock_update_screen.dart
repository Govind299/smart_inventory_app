import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:smart_inventory_app/core/theme.dart';
import 'package:smart_inventory_app/models/inventory_models.dart';
import 'package:smart_inventory_app/services/inventory_provider.dart';

class StockUpdateScreen extends ConsumerStatefulWidget {
  const StockUpdateScreen({super.key});

  @override
  ConsumerState<StockUpdateScreen> createState() => _StockUpdateScreenState();
}

class _StockUpdateScreenState extends ConsumerState<StockUpdateScreen> {
  bool isStockIn = true;
  Product? selectedProduct;
  final qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stock In / Out')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTypeToggle(),
            const SizedBox(height: 32),
            _buildProductSelector(products),
            const SizedBox(height: 24),
            _buildQuantityField(),
            const SizedBox(height: 24),
            if (selectedProduct != null) _buildSummaryCard(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isStockIn = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(color: isStockIn ? AppTheme.successColor : Colors.transparent, borderRadius: BorderRadius.circular(16)),
                child: Center(child: Text('Stock In', style: TextStyle(color: isStockIn ? Colors.white : Colors.black, fontWeight: FontWeight.bold))),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isStockIn = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(color: !isStockIn ? AppTheme.dangerColor : Colors.transparent, borderRadius: BorderRadius.circular(16)),
                child: Center(child: Text('Stock Out', style: TextStyle(color: !isStockIn ? Colors.white : Colors.black, fontWeight: FontWeight.bold))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSelector(List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Product', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<Product>(
          value: selectedProduct,
          decoration: InputDecoration(prefixIcon: const Icon(LucideIcons.package), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          hint: const Text('Choose a product'),
          items: products.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
          onChanged: (v) => setState(() => selectedProduct = v),
        ),
      ],
    );
  }

  Widget _buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: qtyController,
          keyboardType: TextInputType.number,
          onChanged: (v) => setState(() {}),
          decoration: InputDecoration(prefixIcon: const Icon(LucideIcons.hash), hintText: 'Enter amount', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final change = int.tryParse(qtyController.text) ?? 0;
    final newBalance = isStockIn ? selectedProduct!.quantity + change : selectedProduct!.quantity - change;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Current Stock', style: TextStyle(color: Colors.grey)),
            Text('${selectedProduct!.quantity} units', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          const Icon(LucideIcons.arrowRight, color: Colors.grey),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('New Balance', style: TextStyle(color: Colors.grey)),
            Text('$newBalance units', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: newBalance < 0 ? AppTheme.dangerColor : AppTheme.successColor)),
          ]),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(isStockIn ? 'Confirm Stock In' : 'Confirm Stock Out'),
      ),
    );
  }

  void _handleSubmit() {
    if (selectedProduct == null || qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a product and quantity')));
      return;
    }

    final change = int.tryParse(qtyController.text) ?? 0;
    if (change <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid positive quantity')));
      return;
    }

    if (!isStockIn && selectedProduct!.quantity < change) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Not enough stock available!')));
      return;
    }

    // Update State
    final type = isStockIn ? StockLogType.stockIn : StockLogType.stockOut;
    ref.read(productProvider.notifier).updateStock(selectedProduct!.id, change, type);
    
    // Add Log
    ref.read(stockLogProvider.notifier).addLog(StockLog.create(
      productId: selectedProduct!.id,
      productName: selectedProduct!.name,
      type: type,
      quantity: change,
    ));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Stock updated successfully!'),
      backgroundColor: isStockIn ? AppTheme.successColor : AppTheme.primaryColor,
    ));
    
    Navigator.pop(context);
  }
}
