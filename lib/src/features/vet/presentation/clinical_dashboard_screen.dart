import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/app_drawer.dart';

class ClinicalDashboardScreen extends StatefulWidget {
  const ClinicalDashboardScreen({super.key});

  @override
  State<ClinicalDashboardScreen> createState() => _ClinicalDashboardScreenState();
}

class _ClinicalDashboardScreenState extends State<ClinicalDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  final List<Map<String, dynamic>> _appointments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showPrescriptionBuilderModal() {
    final drugCtrl = TextEditingController();
    final dosageCtrl = TextEditingController(text: '1 Tablet daily');
    final durationCtrl = TextEditingController(text: '7 Days');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Digital Prescription Builder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            AppSpacing.gapLg,
            TextField(
              controller: drugCtrl,
              decoration: const InputDecoration(labelText: 'Medication Name (e.g. Amoxicillin)', border: OutlineInputBorder()),
            ),
            AppSpacing.gapMd,
            TextField(
              controller: dosageCtrl,
              decoration: const InputDecoration(labelText: 'Dosage & Frequency', border: OutlineInputBorder()),
            ),
            AppSpacing.gapMd,
            TextField(
              controller: durationCtrl,
              decoration: const InputDecoration(labelText: 'Duration / Days', border: OutlineInputBorder()),
            ),
            AppSpacing.gapLg,
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digital Rx signed and exported as official PDF!')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Sign & Export Digital Rx PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Veterinarian Clinical Hub'),
            Text('Metro Pet Hospital • Dr. Sarah Jenkins (DVM)', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            tooltip: 'Issue Rx',
            onPressed: _showPrescriptionBuilderModal,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryTeal,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Appointments'),
            Tab(text: 'Patients EHR'),
            Tab(text: 'Rx Builder'),
            Tab(text: 'Calendar'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.vetDashboard),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        onPressed: _showPrescriptionBuilderModal,
        icon: const Icon(Icons.medication),
        label: const Text('New Digital Rx'),
      ),
      body: Column(
        children: [
          Container(
            padding: AppSpacing.paddingMd,
            color: AppColors.primaryTeal.withOpacity(0.06),
            child: Row(
              children: [
                Expanded(child: _buildMetricItem('Today Consults', '12', Icons.calendar_month, AppColors.primaryTeal)),
                AppSpacing.gapSm,
                Expanded(child: _buildMetricItem('Emergency Triage', '2', Icons.emergency, AppColors.errorRed)),
                AppSpacing.gapSm,
                Expanded(child: _buildMetricItem('AI Scans', '5', Icons.psychology, AppColors.secondaryCyan)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search patient pet name or owner phone...',
                prefixIcon: Icon(Icons.search, color: AppColors.primaryTeal),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onChanged: (v) => setState(() => _searchQuery = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  padding: AppSpacing.paddingLg,
                  children: [
                    ..._appointments.where((a) => _searchQuery.isEmpty || a['pet'].toString().toLowerCase().contains(_searchQuery)).map((apt) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.primaryTeal,
                            child: Icon(Icons.pets, color: Colors.white),
                          ),
                          title: Text(apt['pet'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Owner: ${apt['owner']} • ${apt['time']}\nType: ${apt['type']}'),
                          isThreeLine: true,
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryTeal.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(apt['status'] as String, style: const TextStyle(fontSize: 10, color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const Center(
                  child: Padding(
                    padding: AppSpacing.paddingLg,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_off_outlined, size: 48, color: Colors.grey),
                        AppSpacing.gapMd,
                        Text('No Patient EHR Records Found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Search for a patient or scan a QR code to load medical records.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: AppSpacing.paddingLg,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.medication_liquid, size: 64, color: AppColors.primaryTeal),
                        AppSpacing.gapLg,
                        const Text('Digital Prescription & Dosage Generator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        AppSpacing.gapSm,
                        const Text('Issue official digital prescriptions backed by DRF medical ledger.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                        AppSpacing.gapLg,
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
                          onPressed: _showPrescriptionBuilderModal,
                          icon: const Icon(Icons.add),
                          label: const Text('Create New Digital Prescription'),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView(
                  padding: AppSpacing.paddingLg,
                  children: [
                    Container(
                      padding: AppSpacing.paddingMd,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('July 2026 Clinical Schedule', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Icon(Icons.calendar_month, color: AppColors.primaryTeal),
                            ],
                          ),
                          SizedBox(height: 12),
                          ListTile(
                            leading: CircleAvatar(backgroundColor: AppColors.primaryTeal, child: Text('31', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            title: Text('Today - 3 Scheduled Consults'),
                            subtitle: Text('First consult at 10:30 AM'),
                          ),
                          ListTile(
                            leading: CircleAvatar(backgroundColor: Colors.grey, child: Text('01', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            title: Text('Tomorrow - 5 Scheduled Consults'),
                            subtitle: Text('Includes 2 AI Scan reviews'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
