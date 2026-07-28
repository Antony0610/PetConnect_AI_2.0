import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_container.dart';

class LiveRescueMapScreen extends StatelessWidget {
  const LiveRescueMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Dispatch Radar Map')),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF0F172A),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: AppColors.secondaryCyan),
                  SizedBox(height: 12),
                  Text('Live Interactive Dispatch Radar View', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Active Rescuers: 14 • Pending Alerts: 3', style: TextStyle(color: AppColors.secondaryFixedDim)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: GlassContainer(
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Search sector or volunteer ID...', style: TextStyle(color: Colors.white70)),
                  ),
                  IconButton(icon: const Icon(Icons.tune, color: Colors.white), onPressed: () {}),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
