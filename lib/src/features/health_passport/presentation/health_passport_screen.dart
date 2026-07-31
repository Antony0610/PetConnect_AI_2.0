import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/app_drawer.dart';

class HealthPassportScreen extends StatefulWidget {
  const HealthPassportScreen({super.key});

  @override
  State<HealthPassportScreen> createState() => _HealthPassportScreenState();
}

class _HealthPassportScreenState extends State<HealthPassportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  final List<Map<String, dynamic>> _vaccines = [
    {
      'title': 'Rabies 3-Year Vaccine',
      'date': 'Jan 15, 2025',
      'expires': 'Jan 15, 2028',
      'vet': 'Dr. Sarah Jenkins (City Vet)',
      'status': 'Up-to-Date',
      'batch': 'RB-984210',
    },
    {
      'title': 'DHPP Core Booster',
      'date': 'Nov 10, 2024',
      'expires': 'Nov 10, 2025',
      'vet': 'Dr. Sarah Jenkins (City Vet)',
      'status': 'Up-to-Date',
      'batch': 'DH-441092',
    },
    {
      'title': 'Bordetella Oral Vaccine',
      'date': 'Jun 02, 2024',
      'expires': 'Jun 02, 2025',
      'vet': 'Paws & Claws Clinic',
      'status': 'Pending Booster',
      'batch': 'BO-110293',
    },
  ];

  final List<Map<String, dynamic>> _medications = [
    {
      'name': 'Heartgard Plus (Ivermectin)',
      'dosage': '1 Chewable / Month',
      'prescribed': 'Dr. Sarah Jenkins',
      'refills': '3 Remaining',
    },
    {
      'name': 'NexGard Flea & Tick',
      'dosage': '1 Tablet / Month',
      'prescribed': 'Dr. Sarah Jenkins',
      'refills': '5 Remaining',
    },
  ];

  final List<Map<String, dynamic>> _documents = [
    {
      'title': 'Official Health Certificate.pdf',
      'size': '1.2 MB',
      'date': 'May 12, 2026',
    },
    {
      'title': 'Bloodwork CBC Diagnostic Report.pdf',
      'size': '3.4 MB',
      'date': 'Apr 02, 2026',
    },
  ];

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

  void _showQrCodeModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.qr_code, color: AppColors.primaryTeal),
            SizedBox(width: 8),
            Text('Passport QR Check-In'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryTeal, width: 2),
              ),
              child: const Icon(Icons.qr_code_2, size: 160, color: AppColors.primaryTeal),
            ),
            AppSpacing.gapMd,
            const Text('Scan this QR code at veterinary clinics to load Luna\'s verified medical passport instantly.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Health Passport'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'QR Passport',
            onPressed: _showQrCodeModal,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Passport',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Health Passport link & PDF export ready for sharing.')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryTeal,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Vaccines'),
            Tab(text: 'Meds & History'),
            Tab(text: 'Timeline'),
            Tab(text: 'Documents'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.healthPassport),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document upload picker open. Select PDF or image.')),
          );
        },
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Report'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search vaccine, record, document...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryTeal),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  padding: AppSpacing.paddingLg,
                  children: [
                    ..._vaccines.where((v) => _searchQuery.isEmpty || v['title'].toString().toLowerCase().contains(_searchQuery)).map((v) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.primaryTeal,
                            child: Icon(Icons.verified, color: Colors.white),
                          ),
                          title: Text(v['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${v['date']} • Expires: ${v['expires']}'),
                              Text('Batch: ${v['batch']} • ${v['vet']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryTeal.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(v['status'] as String, style: const TextStyle(color: AppColors.primaryTeal, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                ListView(
                  padding: AppSpacing.paddingLg,
                  children: [
                    Text('Active Medications', style: AppTypography.headlineMedium(context)),
                    AppSpacing.gapMd,
                    ..._medications.map((m) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.secondaryCyan,
                            child: Icon(Icons.medication, color: Colors.white),
                          ),
                          title: Text(m['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Dosage: ${m['dosage']} • Refills: ${m['refills']}'),
                        ),
                      );
                    }),
                    AppSpacing.gapLg,
                    Text('Allergies & Dietary Constraints', style: AppTypography.headlineMedium(context)),
                    AppSpacing.gapMd,
                    Container(
                      padding: AppSpacing.paddingMd,
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryCoral.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.tertiaryCoral.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: AppColors.tertiaryCoral),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text('Allergic to Artificial Flavoring & Dairy. Grain-free salmon diet prescribed.'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ListView(
                  padding: AppSpacing.paddingLg,
                  children: [
                    _buildTimelineNode(context, 'May 12, 2026', 'Annual Health Checkup & Bloodwork', 'Complete CBC panel within normal limits. Dr. Sarah Jenkins.'),
                    _buildTimelineNode(context, 'Jan 15, 2025', 'Rabies 3-Year Vaccine Administered', 'Vaccine batch #RB-984210. Valid through 2028.'),
                    _buildTimelineNode(context, 'Nov 10, 2024', 'DHPP Core Booster Shot', 'No adverse reactions noted. Hydration optimal.'),
                    _buildTimelineNode(context, 'Jun 02, 2024', 'Dental Scaling & Polishing', 'Routine cleaning under sedation. Teeth clean.'),
                  ],
                ),
                ListView(
                  padding: AppSpacing.paddingLg,
                  children: [
                    ..._documents.map((doc) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.primaryTeal,
                            child: Icon(Icons.picture_as_pdf, color: Colors.white),
                          ),
                          title: Text(doc['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${doc['size']} • Uploaded ${doc['date']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.download, color: AppColors.primaryTeal),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Downloading ${doc['title']}...')),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share, color: Colors.grey),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(BuildContext context, String date, String title, String description) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
              ),
              Expanded(
                child: Container(width: 2, color: AppColors.primaryTeal.withOpacity(0.3)),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: const TextStyle(fontSize: 11, color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
