import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/repositories/pets_repository.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/status_chip.dart';

class HealthPassportScreen extends StatefulWidget {
  const HealthPassportScreen({super.key});

  @override
  State<HealthPassportScreen> createState() => _HealthPassportScreenState();
}

class _HealthPassportScreenState extends State<HealthPassportScreen> {
  final PetsRepository _petsRepository = PetsRepository();
  Map<String, dynamic> _passportData = {};
  bool _isLoading = true;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadHealthPassport();
  }

  Future<void> _loadHealthPassport() async {
    final data = await _petsRepository.getHealthPassport('pet_001');
    if (mounted) {
      setState(() {
        _passportData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Health Passport'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Passport',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Health Passport QR Link copied to clipboard')),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Generating Verified EHR Medical Records PDF...')),
          );
        },
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text('Export Verified EHR'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal))
          : RefreshIndicator(
              onRefresh: _loadHealthPassport,
              color: AppColors.primaryTeal,
              child: SingleChildScrollView(
                padding: AppSpacing.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassContainer(
                      padding: AppSpacing.paddingLg,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 36,
                                backgroundColor: AppColors.primaryTeal,
                                child: Icon(Icons.pets, size: 40, color: Colors.white),
                              ),
                              AppSpacing.gapMd,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Luna', style: AppTypography.headlineMedium(context)),
                                    Text('Canine • Golden Retriever • 3 yrs 2 mos', style: AppTypography.bodyMedium(context)),
                                    Text('Microchip ID: 985141002938102', style: AppTypography.labelLarge(context)),
                                  ],
                                ),
                              ),
                              const StatusChip(label: 'Verified EHR', type: StatusType.success),
                            ],
                          ),
                          AppSpacing.gapLg,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Core Vaccine Compliance', style: AppTypography.titleMedium(context)),
                                  const Text('100% Up to Date', style: TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: const LinearProgressIndicator(
                                  value: 1.0,
                                  minHeight: 8,
                                  backgroundColor: Colors.white12,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.successGreen),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.gapLg,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All Immunizations', 0),
                          const SizedBox(width: 8),
                          _buildFilterChip('Medical Ledger', 1),
                          const SizedBox(width: 8),
                          _buildFilterChip('Surgeries & Care', 2),
                        ],
                      ),
                    ),
                    AppSpacing.gapLg,
                    Text('Vaccination History', style: AppTypography.headlineMedium(context)),
                    AppSpacing.gapMd,
                    _buildRecordItem(
                      context,
                      title: 'Rabies 3-Year Vaccine',
                      date: 'Administered: Jan 15, 2025 • Expires: Jan 15, 2028',
                      vet: 'Dr. Sarah Jenkins, DVM',
                      isVerified: true,
                    ),
                    _buildRecordItem(
                      context,
                      title: 'DHPP Core Booster',
                      date: 'Administered: Nov 10, 2024 • Expires: Nov 10, 2025',
                      vet: 'Dr. Sarah Jenkins, DVM',
                      isVerified: true,
                    ),
                    _buildRecordItem(
                      context,
                      title: 'Bordetella Oral Vaccine',
                      date: 'Administered: Jun 02, 2024 • Expires: Jun 02, 2025',
                      vet: 'Metro Pet Care Clinic',
                      isVerified: true,
                    ),
                    AppSpacing.gapLg,
                    Text('Medical & Surgery Ledger', style: AppTypography.headlineMedium(context)),
                    AppSpacing.gapMd,
                    _buildRecordItem(
                      context,
                      title: 'Routine Dental Scaling & Polish',
                      date: 'Performed: Aug 14, 2024',
                      vet: 'Metro Pet Care Clinic',
                      isVerified: true,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryTeal,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      backgroundColor: Colors.white10,
      onSelected: (selected) {
        if (selected) setState(() => _selectedTabIndex = index);
      },
    );
  }

  Widget _buildRecordItem(
    BuildContext context, {
    required String title,
    required String date,
    required String vet,
    required bool isVerified,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassContainer(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified, color: AppColors.primaryTeal, size: 24),
            ),
            AppSpacing.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleLarge(context)),
                  const SizedBox(height: 2),
                  Text(date, style: AppTypography.bodyMedium(context)),
                  Text(vet, style: AppTypography.labelLarge(context)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.lightOutlineVariant),
          ],
        ),
      ),
    );
  }
}
