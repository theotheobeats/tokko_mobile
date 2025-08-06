import 'package:flutter/material.dart';

import '../../app/theme.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: navigate to add/edit product
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Product tapped')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
        backgroundColor: const Color(0xFF16A34A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventory',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Manage your products and stock levels',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories button card (full width)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _CardContainer(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // TODO: open categories screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Categories tapped')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      child: Row(
                        children: [
                          Icon(Icons.inventory_2, color: scheme.onSurfaceVariant),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Categories',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // KPI Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: const [
                    _KpiCard(
                      title: 'Total Products',
                      value: '4',
                      icon: Icons.inventory_2_outlined,
                      iconColor: null,
                    ),
                    SizedBox(height: 16),
                    _KpiCard(
                      title: 'Low Stock Items',
                      value: '1',
                      icon: Icons.error_outline,
                      iconColor: Color(0xFFDC2626),
                    ),
                  ],
                ),
              ),
            ),

            // Products section with action buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: _CardContainer(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Products',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          )),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _ActionChipButton(
                            icon: Icons.checklist_rtl,
                            label: 'Opname',
                            onTap: () {},
                          ),
                          _ActionChipButton(
                            icon: Icons.add,
                            label: 'Update',
                            onTap: () {},
                          ),
                          _ActionChipButton(
                            icon: Icons.history,
                            label: 'History',
                            onTap: () {},
                          ),
                          _ActionChipButton(
                            icon: Icons.refresh,
                            label: 'Reset',
                            onTap: () {},
                            foreground: const Color(0xFFDC2626),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Search field
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (v) {
                          // TODO: wire to search
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Category chips/tabs (All, Low, Out)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      _CategoryFilterChip(label: 'All', selected: true),
                      SizedBox(width: 8),
                      _CategoryFilterChip(label: 'Low Stock'),
                      SizedBox(width: 8),
                      _CategoryFilterChip(label: 'Out of Stock'),
                    ],
                  ),
                ),
              ),
            ),

            // Product list placeholder with slidable-ready rows
            SliverList.separated(
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _ProductListTile(
                    name: 'Sample Product ${index + 1}',
                    price: 15000 + (index * 500),
                    stock: [12, 2, 0, 7, 30, 1][index % 6],
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  const _CardContainer({required this.child, this.padding, this.background});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: background ?? (isDark ? scheme.surface : Colors.white),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return _CardContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: iconColor ?? scheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.foreground,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: foreground ?? scheme.onSurface),
        label: Text(
          label,
          style: TextStyle(
            color: foreground ?? scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? scheme.surface
              : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({required this.label, this.selected = false});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {},
      selectedColor: scheme.primary.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      side: BorderSide(color: scheme.outlineVariant),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  const _ProductListTile({
    required this.name,
    required this.price,
    required this.stock,
  });

  final String name;
  final int price;
  final int stock;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color stockColor;
    if (stock == 0) {
      stockColor = AppTheme.error;
    } else if (stock <= 3) {
      stockColor = const Color(0xFFF59E0B); // amber-ish
    } else {
      stockColor = AppTheme.success;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.image, size: 24),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text(
                stock == 0 ? 'Out of stock' : 'Stock: $stock',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: stockColor,
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              side: BorderSide.none,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: 8),
            Text('Rp${price.toString()}',
                style: TextStyle(color: scheme.onSurfaceVariant)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Decrease',
              onPressed: () {},
              icon: const Icon(Icons.remove_circle_outline),
            ),
            IconButton(
              tooltip: 'Increase',
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline),
            ),
            PopupMenuButton(
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              onSelected: (value) {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}