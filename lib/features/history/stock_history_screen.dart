import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:smart_inventory_app/core/theme.dart';
import 'package:smart_inventory_app/models/inventory_models.dart';
import 'package:smart_inventory_app/services/inventory_provider.dart';

class StockHistoryScreen extends ConsumerWidget {
  const StockHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(stockLogProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock History'),
        actions: [
          IconButton(icon: const Icon(LucideIcons.filter), onPressed: () {}),
        ],
      ),
      body: logs.isEmpty
        ? const Center(child: Text('No transactions recorded yet.'))
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final log = logs[index];
              return _HistoryTile(log: log);
            },
          ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final StockLog log;
  const _HistoryTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final isIn = log.type == StockLogType.stockIn;
    final dateStr = DateFormat('MMM dd, yyyy • HH:mm').format(log.timestamp);

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
                Text(log.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(dateStr, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(
            '${isIn ? '+' : '-'}${log.quantity}',
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
