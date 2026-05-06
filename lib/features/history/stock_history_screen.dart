import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:smart_inventory_app/core/theme.dart';

class StockHistoryScreen extends StatelessWidget {
  const StockHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock History'),
        actions: [
          IconButton(icon: const Icon(LucideIcons.filter), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 15,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final isEven = index % 2 == 0;
          return _HistoryTile(
            productName: isEven ? 'Surgical Gloves' : 'Beaker 500ml',
            type: isEven ? 'STOCK_IN' : 'STOCK_OUT',
            qty: isEven ? 50 : 5,
            date: 'May 06, 2026 • 14:30',
          );
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final String productName;
  final String type;
  final int qty;
  final String date;

  const _HistoryTile({required this.productName, required this.type, required this.qty, required this.date});

  @override
  Widget build(BuildContext context) {
    final isIn = type == 'STOCK_IN';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isIn ? AppTheme.successColor : AppTheme.dangerColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isIn ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
              color: isIn ? AppTheme.successColor : AppTheme.dangerColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(
            '${isIn ? '+' : '-'}$qty',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isIn ? AppTheme.successColor : AppTheme.dangerColor,
            ),
          ),
        ],
      ),
    );
  }
}
