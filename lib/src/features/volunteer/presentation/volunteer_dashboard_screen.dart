import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/app_drawer.dart';

class VolunteerDashboardScreen extends StatefulWidget {
  const VolunteerDashboardScreen({super.key});

  @override
  State<VolunteerDashboardScreen> createState() => _VolunteerDashboardScreenState();
}

class _VolunteerDashboardScreenState extends State<VolunteerDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isOnDuty = true;
  String _availabilityStatus = 'On Duty (Dispatch Ready)';

  final List<Map<String, dynamic>> _activeRescues = [
    {
      'id': 'res_1',
      'title': 'Injured Stray Terrier Alert',
      'distance': '0.8 km away',
      'location': 'Central Park East Gate (Bench #14)',
      'reporter': 'Mark Stevenson (+1 555-0199)',
      'time': '12 mins ago',
      'urgency': 'High Priority',
      'status': 'Dispatched',
      'eta': '8 mins',
    },
    {
      'id': 'res_2',
      'title': 'Lost Tabby Cat (Microchipped #441092)',
      'distance': '1.4 km away',
      'location': '5th Avenue Subway Station Entrance',
      'reporter': 'Sarah Lee (+1 555-4422)',
      'time': '34 mins ago',
      'urgency': 'Medium Priority',
      'status': 'Reported',
      'eta': '15 mins',
    },
  ];

  final List<Map<String, dynamic>> _communityFeed = [
    {
      'author': 'Officer Dan (Rescue Unit 4)',
      'time': '2 hours ago',
      'content': 'Successfully rescued a Golden Retriever stray near 4th street! Transferred to Metro Vet Clinic for chip scan.',
      'likes': 24,
    },
    {
      'author': 'Shelter Team Alpha',
      'time': '5 hours ago',
      'content': 'Adopt-A-Pet Drive scheduled for Saturday at City Park! 12 foster pets available.',
      'likes': 45,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCaseDetailsModal(Map<String, dynamic> caseItem) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(caseItem['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.errorRed.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(caseItem['urgency'] as String, style: const TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ],
            ),
            AppSpacing.gapMd,
            Text('Location: ${caseItem['location']} (${caseItem['distance']})', style: const TextStyle(color: Colors.grey)),
            Text('Reporter Contact: ${caseItem['reporter']}', style: const TextStyle(color: Colors.grey)),
            Text('ETA: ${caseItem['eta']} • Current Status: ${caseItem['status']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
            AppSpacing.gapLg,
            const Text('Update Incident Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            AppSpacing.gapSm,
            Wrap(
              spacing: 8,
              children: ['Dispatched', 'On Scene', 'Rescued', 'Transferred to Vet'].map((st) {
                return OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => caseItem['status'] = st);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Incident status updated to "$st"')),
                    );
                  },
                  child: Text(st),
                );
              }).toList(),
            ),
            AppSpacing.gapLg,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${caseItem['reporter']}...')),
                      );
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Call Reporter'),
                  ),
                ),
                AppSpacing.gapSm,
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.go(AppRoutes.rescueMap);
                    },
                    icon: const Icon(Icons.navigation),
                    label: const Text('Start Navigation'),
                  ),
                ),
              ],
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
        title: const Text('Volunteer & Rescue Portal'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryTeal,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Active Rescues'),
            Tab(text: 'Community Feed'),
            Tab(text: 'Duty Radar'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.volunteerDashboard),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primaryTeal.withOpacity(0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(_isOnDuty ? Icons.check_circle : Icons.pause_circle, color: _isOnDuty ? Colors.green : Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    Text(_availabilityStatus, style: TextStyle(fontWeight: FontWeight.bold, color: _isOnDuty ? Colors.green.shade700 : Colors.grey)),
                  ],
                ),
                Switch(
                  value: _isOnDuty,
                  activeColor: Colors.green,
                  onChanged: (v) {
                    setState(() {
                      _isOnDuty = v;
                      _availabilityStatus = v ? 'On Duty (Dispatch Ready)' : 'Off Duty (Standby)';
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  padding: AppSpacing.paddingLg,
                  itemCount: _activeRescues.length,
                  itemBuilder: (context, index) {
                    final item = _activeRescues[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.errorRed,
                          child: Icon(Icons.warning, color: Colors.white),
                        ),
                        title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item['location']} • ${item['distance']}'),
                            Text('Status: ${item['status']} • ETA: ${item['eta']}', style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
                          onPressed: () => _showCaseDetailsModal(item),
                          child: const Text('Details'),
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  padding: AppSpacing.paddingLg,
                  itemCount: _communityFeed.length,
                  itemBuilder: (context, index) {
                    final post = _communityFeed[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: AppSpacing.paddingMd,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(backgroundColor: AppColors.primaryTeal, child: Icon(Icons.person, color: Colors.white)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(post['author'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text(post['time'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(post['content'] as String),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.favorite_border, color: AppColors.tertiaryCoral, size: 18),
                                  onPressed: () {},
                                ),
                                Text('${post['likes']} likes', style: const TextStyle(fontSize: 12)),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.share, size: 18, color: Colors.grey),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Center(
                  child: Padding(
                    padding: AppSpacing.paddingLg,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.radar, size: 64, color: AppColors.primaryTeal),
                        AppSpacing.gapLg,
                        const Text('Live Rescue Radar & GPS Dispatch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        AppSpacing.gapSm,
                        const Text('Real-time map tracking for active stray alerts, volunteer locations, and turn-by-turn navigation.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                        AppSpacing.gapLg,
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
                          onPressed: () => context.go(AppRoutes.rescueMap),
                          icon: const Icon(Icons.map),
                          label: const Text('Open Live Rescue Map Radar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
