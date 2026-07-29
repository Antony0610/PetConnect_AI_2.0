import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/pets_repository.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/status_chip.dart';

class ClinicalDashboardScreen extends StatefulWidget {
  const ClinicalDashboardScreen({super.key});

  @override
  State<ClinicalDashboardScreen> createState() => _ClinicalDashboardScreenState();
}

class _ClinicalDashboardScreenState extends State<ClinicalDashboardScreen> {
  final PetsRepository _petsRepository = PetsRepository();
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _allPatients = [
    {
      'petName': 'Luna (Golden Retriever)',
      'ownerName': 'Owner: Alex Morgan',
      'reason': 'Routine Vitals & Dental Scaling Checkup',
      'time': '10:30 AM',
      'status': StatusType.success,
      'statusText': 'Checked In',
      'category': 1, // Checked In
    },
    {
      'petName': 'Max (German Shepherd)',
      'ownerName': 'Owner: Rachel Green',
      'reason': 'AI Skin Lesion Alert Scan Review',
      'time': '11:15 AM',
      'status': StatusType.warning,
      'statusText': 'AI Flagged',
      'category': 2, // AI Flagged
    },
    {
      'petName': 'Bella (Persian Cat)',
      'ownerName': 'Owner: David Miller',
      'reason': 'Teleconsultation Follow-up',
      'time': '02:00 PM',
      'status': StatusType.info,
      'statusText': 'Teleconsult',
      'category': 3, // Teleconsult
    },
  ];

  void _showPatientEHRModal(BuildContext context, Map<String, dynamic> patient) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              AppSpacing.gapLg,
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primaryTeal,
                    radius: 24,
                    child: Icon(Icons.medical_information, color: Colors.white),
                  ),
                  AppSpacing.gapMd,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(patient['petName'], style: AppTypography.titleLarge(context).copyWith(color: Colors.white)),
                      Text(patient['ownerName'], style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
              AppSpacing.gapLg,
              Text('Chief Complaint / Reason:', style: AppTypography.titleMedium(context).copyWith(color: AppColors.secondaryCyan)),
              Text(patient['reason'], style: const TextStyle(color: Colors.white)),
              AppSpacing.gapLg,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                      onPressed: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.healthPassport);
                      },
                      icon: const Icon(Icons.folder_shared, color: Colors.white),
                      label: const Text('Open EHR Passport', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = _searchController.text.toLowerCase();
    final filteredPatients = _allPatients.where((patient) {
      final matchesSearch = patient['petName'].toLowerCase().contains(searchQuery) ||
          patient['ownerName'].toLowerCase().contains(searchQuery);
      final matchesFilter = _selectedFilterIndex == 0 || patient['category'] == _selectedFilterIndex;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Veterinarian Clinical Hub'),
            Text('Metro Pet Hospital • Dr. Sarah Jenkins', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            tooltip: 'Switch Portal',
            onPressed: () => context.go(AppRoutes.roleSelection),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _isLoading = true);
          await Future.delayed(const Duration(milliseconds: 600));
          if (mounted) setState(() => _isLoading = false);
        },
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clinical Metrics Summary Row
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(context, 'Today Consults', '12', Icons.calendar_month, AppColors.primaryTeal),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: _buildMetricTile(context, 'Emergency Triage', '2', Icons.error_outline, AppColors.errorRed),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: _buildMetricTile(context, 'AI Flagged Scans', '5', Icons.psychology, AppColors.secondaryCyan),
                  ),
                ],
              ),
              AppSpacing.gapLg,

              // Patient Queue Search Bar
              TextField(
                controller: _searchController,
                onChanged: (v) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search patient name or owner ID...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryTeal),
                  fillColor: Colors.black26,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              AppSpacing.gapMd,

              // Filter Choice Chips Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All Queue', 0),
                    const SizedBox(width: 8),
                    _buildFilterChip('Checked In', 1),
                    const SizedBox(width: 8),
                    _buildFilterChip('AI Flagged', 2),
                    const SizedBox(width: 8),
                    _buildFilterChip('Teleconsult', 3),
                  ],
                ),
              ),
              AppSpacing.gapLg,

              Text('Clinical Patient Queue', style: AppTypography.headlineMedium(context)),
              AppSpacing.gapMd,

              if (filteredPatients.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text('No patients match the search criteria', style: TextStyle(color: Colors.white54)),
                  ),
                )
              else
                ...filteredPatients.map(
                  (patient) => GestureDetector(
                    onTap: () => _showPatientEHRModal(context, patient),
                    child: _buildPatientTile(
                      context,
                      petName: patient['petName'],
                      ownerName: patient['ownerName'],
                      reason: patient['reason'],
                      time: patient['time'],
                      status: patient['status'],
                      statusText: patient['statusText'],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryTeal,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      backgroundColor: Colors.white10,
      onSelected: (selected) {
        if (selected) setState(() => _selectedFilterIndex = index);
      },
    );
  }

  Widget _buildMetricTile(BuildContext context, String label, String value, IconData icon, Color color) {
    return GlassContainer(
      padding: AppSpacing.paddingSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value, style: AppTypography.headlineLarge(context).copyWith(color: color, fontSize: 22)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildPatientTile(
    BuildContext context, {
    required String petName,
    required String ownerName,
    required String reason,
    required String time,
    required StatusType status,
    required String statusText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(petName, style: AppTypography.titleLarge(context)),
                ),
                StatusChip(label: statusText, type: status),
              ],
            )
          ],
        ),
      ),
    );
  }
}
