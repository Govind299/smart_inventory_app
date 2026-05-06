import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_inventory_app/features/dashboard/dashboard_screen.dart';
import 'package:smart_inventory_app/features/products/product_management_screen.dart';
import 'package:smart_inventory_app/features/stock/stock_update_screen.dart';
import 'package:smart_inventory_app/features/history/stock_history_screen.dart';
import 'package:smart_inventory_app/features/search/search_filter_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductManagementScreen(),
    ),
    GoRoute(
      path: '/stock-update',
      builder: (context, state) => const StockUpdateScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const StockHistoryScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchFilterScreen(),
    ),
  ],
);
