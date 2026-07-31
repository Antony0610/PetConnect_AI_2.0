import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../routing/app_router.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeCategory = 'All';
  String _query = '';

  final List<Map<String, dynamic>> _allItems = [
    {
      'title': 'Luna',
      'category': 'Pets',
      'subtitle': 'Golden Retriever • Smart Collar ID #9842',
      'icon': Icons.pets,
      'route': AppRoutes.petOwnerDashboard,
    },
    {
      'title': 'Max',
      'category': 'Pets',
      'subtitle': 'German Shepherd • Vaccinated Up-to-Date',
      'icon': Icons.pets,
      'route': AppRoutes.petOwnerDashboard,
    },
    {
      'title': 'Rabies Vaccine Certificate',
      'category': 'Health Passport',
      'subtitle': 'Administered: June 14, 2026 • Valid 3 Yrs',
      'icon': Icons.medical_information,
      'route': AppRoutes.healthPassport,
    },
    {
      'title': 'Bloodwork & Hematology Report',
      'category': 'Health Passport',
      'subtitle': 'CBC Panel Normal • Dr. Sarah Jenkins',
      'icon': Icons.description,
      'route': AppRoutes.healthPassport,
    },
    {
      'title': 'Injured Stray Terrier Alert',
      'category': 'Volunteer Cases',
      'subtitle': 'Location: 4th Ave Park • Status: Dispatched',
      'icon': Icons.emergency,
      'route': AppRoutes.rescueHub,
    },
    {
      'title': 'Dr. Robert Vance (DVM)',
      'category': 'Vet Patients',
      'subtitle': 'Senior Veterinary Surgeon • City Vet Hospital',
      'icon': Icons.local_hospital,
      'route': AppRoutes.vetDashboard,
    },
    {
      'title': 'Admin System Audit Log #882',
      'category': 'Admin Users',
      'subtitle': 'Role Access Modification • Granted Vet Status',
      'icon': Icons.admin_panel_settings,
      'route': AppRoutes.adminDashboard,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allItems.where((item) {
      final matchesCategory = _activeCategory == 'All' || item['category'] == _activeCategory;
      final matchesQuery = _query.isEmpty ||
          item['title'].toLowerCase().contains(_query.toLowerCase()) ||
          item['subtitle'].toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search pets, medical records, rescue cases, vets...',
            border: InputBorder.none,
          ),
          onChanged: (val) => setState(() => _query = val.trim()),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['All', 'Pets', 'Health Passport', 'Volunteer Cases', 'Vet Patients', 'Admin Users']
                  .map((cat) {
                final selected = _activeCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: selected,
                    selectedColor: AppColors.primaryTeal,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : null,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (_) => setState(() => _activeCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        AppSpacing.gapMd,
                        Text(
                          'No results for "$_query"',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        AppSpacing.gapSm,
                        const Text('Try adjusting your search query or category filter.', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: AppSpacing.paddingLg,
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryTeal.withOpacity(0.12),
                          child: Icon(item['icon'] as IconData, color: AppColors.primaryTeal),
                        ),
                        title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item['subtitle'] as String),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['category'] as String,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                        onTap: () {
                          final route = item['route'] as String;
                          context.go(route);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
