import 'package:flutter/material.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/revenue_chart_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          PopupMenuButton<String>(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'beclothed.com',
                style: TextStyle(fontSize: 16),
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'site1',
                child: Text('beclothed.com'),
              ),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                DashboardCard(
                  title: 'Total Views',
                  value: '265K',
                  icon: Icons.trending_up,
                  iconColor: Colors.blue,
                  width: constraints.maxWidth > 600 ? (constraints.maxWidth / 2) - 24 : constraints.maxWidth,
                ),
                SizedBox(
                  width: constraints.maxWidth > 600 ? (constraints.maxWidth / 2) - 24 : constraints.maxWidth,
                  child: Row(
                    children: [
                      Expanded(
                        child: DashboardCard(
                          title: 'General',
                          subtitle: 'Images, Videos',
                          icon: Icons.settings,
                          iconColor: Colors.teal,
                          showValue: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DashboardCard(
                          title: 'Notification',
                          subtitle: 'All',
                          icon: Icons.notifications,
                          iconColor: Colors.amber,
                          showValue: false,
                        ),
                      ),
                    ],
                  ),
                ),
                RevenueChartCard(
                  width: constraints.maxWidth,
                ),
                DashboardCard(
                  title: 'Shop Items',
                  value: '173',
                  icon: Icons.store,
                  iconColor: Colors.red,
                  width: constraints.maxWidth > 600 ? (constraints.maxWidth / 2) - 24 : constraints.maxWidth,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
