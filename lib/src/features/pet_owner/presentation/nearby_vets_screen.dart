import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/glass_container.dart';

class NearbyVetsScreen extends StatefulWidget {
  const NearbyVetsScreen({super.key});

  @override
  State<NearbyVetsScreen> createState() => _NearbyVetsScreenState();
}

class _NearbyVetsScreenState extends State<NearbyVetsScreen> {
  final List<Map<String, dynamic>> _clinics = [
    {
      'id': 'c1',
      'name': 'City Veterinary Hospital & Emergency Center',
      'doctor': 'Dr. Sarah Jenkins (DVM)',
      'distance': '1.2 km away',
      'rating': 4.9,
      'reviews': 128,
      'status': 'Open 24/7',
      'address': '742 Evergreen Terrace, Suite 100',
      'phone': '+1 (800) 555-PETS',
      'isEmergency': true,
    },
    {
      'id': 'c2',
      'name': 'Paws & Claws Animal Clinic',
      'doctor': 'Dr. Michael Chang',
      'distance': '2.8 km away',
      'rating': 4.7,
      'reviews': 94,
      'status': 'Open • Closes 8:00 PM',
      'address': '1088 Innovation Way',
      'phone': '+1 (800) 555-0199',
      'isEmergency': false,
    },
    {
      'id': 'c3',
      'name': 'Metropolitan Pet Surgical Hospital',
      'doctor': 'Dr. Elena Rostova',
      'distance': '4.5 km away',
      'rating': 4.9,
      'reviews': 210,
      'status': 'Open • Closes 6:00 PM',
      'address': '350 Medical Center Blvd',
      'phone': '+1 (800) 555-7833',
      'isEmergency': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Vets & Clinics'),
      ),
      drawer: const AppDrawer(currentRoute: '/pet-owner/nearby-vets'),
      body: ListView.builder(
        padding: AppSpacing.paddingLg,
        itemCount: _clinics.length,
        itemBuilder: (context, index) {
          final clinic = _clinics[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassContainer(
              padding: AppSpacing.paddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryTeal.withOpacity(0.15),
                        child: const Icon(Icons.local_hospital, color: AppColors.primaryTeal),
                      ),
                      AppSpacing.gapMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(clinic['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 2),
                            Text(clinic['doctor'] as String, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text('${clinic['rating']} (${clinic['reviews']} reviews)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                const SizedBox(width: 12),
                                Text(clinic['distance'] as String, style: const TextStyle(color: AppColors.primaryTeal, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(child: Text(clinic['address'] as String, style: const TextStyle(fontSize: 12))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (clinic['isEmergency'] as bool)
                              ? AppColors.tertiaryCoral.withOpacity(0.15)
                              : Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          clinic['status'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: (clinic['isEmergency'] as bool) ? AppColors.tertiaryCoral : Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Calling ${clinic['name']}...')),
                            );
                          },
                          icon: const Icon(Icons.phone, size: 16),
                          label: const Text('Call Clinic'),
                        ),
                      ),
                      AppSpacing.gapSm,
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Booking consultation at ${clinic['name']}...')),
                            );
                          },
                          icon: const Icon(Icons.calendar_month, size: 16),
                          label: const Text('Book Consult'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
