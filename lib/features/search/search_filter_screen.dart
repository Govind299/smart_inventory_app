import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:smart_inventory_app/core/theme.dart';
import 'package:smart_inventory_app/services/inventory_provider.dart';

class SearchFilterScreen extends ConsumerStatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  String query = '';
  String? selectedCategory;
  
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    final filteredProducts = products.where((p) {
      final matchesQuery = p.name.toLowerCase().contains(query.toLowerCase());
      final matchesCategory = selectedCategory == null || p.category == selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                hintText: 'Search product name...',
                prefixIcon: const Icon(LucideIcons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  children: [
                    _FilterChip(
                      label: 'All', 
                      isSelected: selectedCategory == null,
                      onSelected: (v) => setState(() => selectedCategory = null),
                    ),
                    ...{for (var p in products) p.category}.map((cat) => _FilterChip(
                      label: cat,
                      isSelected: selectedCategory == cat,
                      onSelected: (v) => setState(() => selectedCategory = cat),
                    )),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 40),
          Expanded(
            child: filteredProducts.isEmpty
              ? const Center(child: Text('No matching products found.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final p = filteredProducts[index];
                    return ListTile(
                      title: Text(p.name),
                      subtitle: Text(p.category),
                      trailing: Text('${p.quantity} units'),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;
  const _FilterChip({required this.label, required this.onSelected, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(color: isSelected ? AppTheme.primaryColor : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
