import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/glass_container.dart';

class AdminCommandCenterScreen extends StatefulWidget {
  const AdminCommandCenterScreen({super.key});

  @override
  State<AdminCommandCenterScreen> createState() => _AdminCommandCenterScreenState();
}

class _AdminCommandCenterScreenState extends State<AdminCommandCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _userSearchController = TextEditingController();

  String _userSearchQuery = '';

  final List<Map<String, dynamic>> _usersList = [
    {'id': 'u1', 'name': 'Alex Morgan', 'email': 'alex@petconnect.ai', 'role': 'Pet Owner', 'status': 'Active'},
    {'id': 'u2', 'name': 'Dr. Sarah Jenkins', 'email': 'sarah.vet@metro.clinic', 'role': 'Veterinarian', 'status': 'Verified'},
    {'id': 'u3', 'name': 'Field Worker #V-402', 'email': 'rescue@shelter.org', 'role': 'Volunteer', 'status': 'Active'},
    {'id': 'u4', 'name': 'System Administrator', 'email': 'admin@petconnect.ai', 'role': 'Administrator', 'status': 'Active'},
  ];

  final Map<String, bool> _featureFlags = {
    'Enable AI Scan v2.4': true,
    'Enable Live Rescue Radar': true,
    'Enable Smart Collar OTA': true,
    'Enable Telehealth Billing': false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userSearchController.dispose();
    super.dispose();
  }

  void _showAddAnnouncementModal() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

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
            const Text('Publish Platform Announcement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            AppSpacing.gapLg,
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Announcement Title', border: OutlineInputBorder())),
            AppSpacing.gapMd,
            TextField(controller: bodyCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Announcement Message Body', border: OutlineInputBorder())),
            AppSpacing.gapLg,
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Platform Announcement broadcasted to all active app sessions!')),
                  );
                },
                icon: const Icon(Icons.campaign),
                label: const Text('Broadcast Announcement'),
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
        title: const Text('Administrator Command Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign),
            tooltip: 'Broadcast Announcement',
            onPressed: _showAddAnnouncementModal,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export CSV Audit',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Platform Audit Report exported as CSV.')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryTeal,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Users & Roles'),
            Tab(text: 'Analytics & AI'),
            Tab(text: 'System Health'),
            Tab(text: 'Feature Flags'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.adminDashboard),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            padding: AppSpacing.paddingLg,
            children: [
              Row(
                children: [
                  Expanded(child: _buildMetricTile(context, 'Active Users', '142,850', Icons.people, AppColors.primaryTeal)),
                  AppSpacing.gapMd,
                  Expanded(child: _buildMetricTile(context, 'Smart Collars', '98,420', Icons.bluetooth_connected, AppColors.secondaryCyan)),
                ],
              ),
              AppSpacing.gapMd,
              Row(
                children: [
                  Expanded(child: _buildMetricTile(context, 'AI Scans (24h)', '34,120', Icons.auto_awesome, AppColors.tertiaryCoral)),
                  AppSpacing.gapMd,
                  Expanded(child: _buildMetricTile(context, 'System Uptime', '99.98%', Icons.verified_user, AppColors.successGreen)),
                ],
              ),
              AppSpacing.gapLg,
              Text('System Probes Status', style: AppTypography.headlineMedium(context)),
              AppSpacing.gapMd,
              const GlassContainer(
                padding: AppSpacing.paddingMd,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ProbeItem(label: 'API Gateway', status: '200 OK', color: Colors.green),
                    _ProbeItem(label: 'PostgreSQL', status: 'Optimal', color: Colors.green),
                    _ProbeItem(label: 'Redis Queue', status: 'Connected', color: Colors.green),
                  ],
                ),
              ),
            ],
          ),
          ListView(
            padding: AppSpacing.paddingLg,
            children: [
              TextField(
                controller: _userSearchController,
                decoration: const InputDecoration(
                  hintText: 'Search users by name, email, or role...',
                  prefixIcon: Icon(Icons.search, color: AppColors.primaryTeal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                onChanged: (val) => setState(() => _userSearchQuery = val.trim().toLowerCase()),
              ),
              AppSpacing.gapLg,
              ..._usersList.where((u) => _userSearchQuery.isEmpty || u['name'].toString().toLowerCase().contains(_userSearchQuery)).map((usr) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryTeal,
                      child: Icon(
                        usr['role'] == 'Veterinarian'
                            ? Icons.medical_services
                            : usr['role'] == 'Volunteer'
                                ? Icons.volunteer_activism
                                : usr['role'] == 'Administrator'
                                    ? Icons.admin_panel_settings
                                    : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(usr['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${usr['email']}\nRole: ${usr['role']}'),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User ${usr['name']} updated: $action')),
                        );
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'Verify Role', child: Text('Verify / Approve Role')),
                        PopupMenuItem(value: 'Suspend', child: Text('Suspend Account')),
                        PopupMenuItem(value: 'Reset Password', child: Text('Trigger Password Reset')),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          ListView(
            padding: AppSpacing.paddingLg,
            children: [
              Text('AI Diagnostic Model Accuracy (Past 7 Days)', style: AppTypography.headlineMedium(context)),
              AppSpacing.gapMd,
              GlassContainer(
                padding: AppSpacing.paddingMd,
                child: SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 94.2),
                            FlSpot(1, 95.8),
                            FlSpot(2, 96.1),
                            FlSpot(3, 97.4),
                            FlSpot(4, 98.2),
                            FlSpot(5, 98.4),
                          ],
                          isCurved: true,
                          color: AppColors.primaryTeal,
                          barWidth: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppSpacing.gapLg,
              const ListTile(
                leading: Icon(Icons.bolt, color: AppColors.secondaryCyan),
                title: Text('Average AI Vision Response Latency'),
                trailing: Text('240 ms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const ListTile(
                leading: Icon(Icons.psychology, color: AppColors.primaryTeal),
                title: Text('Daily Gemini Model Token Usage'),
                trailing: Text('1.4M Tokens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
          ListView(
            padding: AppSpacing.paddingLg,
            children: [
              GlassContainer(
                padding: AppSpacing.paddingMd,
                child: Column(
                  children: [
                    _buildHealthRow('Django API Server', 'Healthy (0.02% Error Rate)', Colors.green),
                    const Divider(),
                    _buildHealthRow('PostgreSQL Connection Pool', '48 / 100 Active Connections', Colors.green),
                    const Divider(),
                    _buildHealthRow('Redis Cache Memory', '1.2 GB / 8.0 GB Used', Colors.green),
                    const Divider(),
                    _buildHealthRow('Collar Telemetry Socket Stream', '98,420 Stream Consumers', Colors.green),
                  ],
                ),
              ),
            ],
          ),
          ListView(
            padding: AppSpacing.paddingLg,
            children: [
              Text('Remote Feature Flags Control', style: AppTypography.headlineMedium(context)),
              AppSpacing.gapMd,
              ..._featureFlags.keys.map((flag) {
                return SwitchListTile(
                  secondary: const Icon(Icons.flag, color: AppColors.primaryTeal),
                  title: Text(flag),
                  value: _featureFlags[flag]!,
                  onChanged: (val) {
                    setState(() => _featureFlags[flag] = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Remote Flag "$flag" updated to $val')),
                    );
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(BuildContext context, String label, String value, IconData icon, Color color) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          AppSpacing.gapSm,
          Text(value, style: AppTypography.headlineLarge(context).copyWith(color: color)),
          Text(label, style: AppTypography.labelLarge(context)),
        ],
      ),
    );
  }

  Widget _buildHealthRow(String label, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProbeItem extends StatelessWidget {
  final String label;
  final String status;
  final Color color;

  const _ProbeItem({required this.label, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text('$label: ', style: const TextStyle(fontSize: 12, color: Colors.white70)),
        Text(status, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
