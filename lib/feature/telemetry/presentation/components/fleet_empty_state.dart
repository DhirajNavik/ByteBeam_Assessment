import 'package:flutter/material.dart';

class FleetEmptyState extends StatelessWidget {
  const FleetEmptyState({super.key, required this.filterLabel});
  final String filterLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_shipping_outlined, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No $filterLabel vehicles',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}