import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:smart_inventory_app/core/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatOverview(),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            const Text(
              'Stock Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStockStatusList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) context.push('/products');
          if (index == 2) context.push('/stock-update');
          if (index == 3) context.push('/history');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.layoutDashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.package), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.plusCircle), label: 'Stock In/Out'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.history), label: 'History'),
        ],
      ),
    );
  }

  Widget _buildStatOverview() {
    return Row(
      children: [
        _StatCard(title: 'Total', value: '42', icon: LucideIcons.package, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        _StatCard(title: 'Low Stock', value: '5', icon: LucideIcons.alertTriangle, color: AppTheme.warningColor),
        const SizedBox(width: 12),
        _StatCard(title: 'Critical', value: '2', icon: LucideIcons.alertCircle, color: AppTheme.dangerColor),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          label: 'Add Product',
          icon: LucideIcons.plus,
          onTap: () => context.push('/products'),
        ),
        const SizedBox(width: 12),
        _ActionButton(
          label: 'Stock In',
          icon: LucideIcons.arrowDownCircle,
          onTap: () => context.push('/stock-update'),
        ),
        const SizedBox(width: 12),
        _ActionButton(
          label: 'Stock Out',
          icon: LucideIcons.arrowUpCircle,
          onTap: () => context.push('/stock-update'),
        ),
      ],
    );
  }

  Widget _buildStockStatusList() {
    return Column(
      children: [
        _StockStatusItem(name: 'Surgical Gloves', category: 'Medical', qty: 150, status: 'Normal'),
        _StockStatusItem(name: 'Beaker 500ml', category: 'Labware', qty: 12, status: 'Low'),
        _StockStatusItem(name: 'Ethanol 95%', category: 'Chemicals', qty: 2, status: 'Critical'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockStatusItem extends StatelessWidget {
  final String name;
  final String category;
  final int qty;
  final String status;

  const _StockStatusItem({required this.name, required this.category, required this.qty, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusColor = status == 'Normal' ? AppTheme.successColor : (status == 'Low' ? AppTheme.warningColor : AppTheme.dangerColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(LucideIcons.box, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(category, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$qty units', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(status, style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
