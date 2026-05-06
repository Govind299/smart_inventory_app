import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:smart_inventory_app/core/theme.dart';

class SearchFilterScreen extends StatelessWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search product name...',
                prefixIcon: const Icon(LucideIcons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 32),
            const Text('Filter by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: [
                _FilterChip(label: 'All', isSelected: true),
                _FilterChip(label: 'Medical'),
                _FilterChip(label: 'Labware'),
                _FilterChip(label: 'Chemicals'),
                _FilterChip(label: 'Equipment'),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Filter by Stock Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: [
                _StatusCheckbox(label: 'Available', color: AppTheme.successColor),
                _StatusCheckbox(label: 'Low Stock', color: AppTheme.warningColor),
                _StatusCheckbox(label: 'Out of Stock', color: AppTheme.dangerColor),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (v) {},
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(color: isSelected ? AppTheme.primaryColor : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _StatusCheckbox extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusCheckbox({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: false,
      onChanged: (v) {},
      title: Text(label),
      secondary: Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}
