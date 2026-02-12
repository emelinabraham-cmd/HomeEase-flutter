import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../theme.dart';
import '../models/service_model.dart';

class ServiceGrid extends StatefulWidget {
  final Function(Service) onServiceSelected;
  const ServiceGrid({super.key, required this.onServiceSelected});

  @override
  State<ServiceGrid> createState() => _ServiceGridState();
}

class _ServiceGridState extends State<ServiceGrid> {
  String? _selectedId;

  void _handleTap(Service service) {
    setState(() {
      _selectedId = service.id;
    });
    widget.onServiceSelected(service);
  }

  @override
  Widget build(BuildContext context) {
    final services = Service.allServices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "எப்படி உதவலாம்?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.brandDark,
          ),
        ),
        const Text(
          "HOW CAN WE HELP TODAY?",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppTheme.brandSlate,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),

        StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            // Row 1 & 2: Large Square (L) + 3 stack (R)
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 2.0,
              child: _buildServiceCard(services[0], true),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 0.65,
              child: _buildServiceCard(services[1], false),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 0.65,
              child: _buildServiceCard(services[2], false),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 0.7,
              child: _buildServiceCard(services[3], false),
            ),

            // Row 3 & 4: Wide Horizontal (L) + Tall Vertical (R)
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.0,
              child: _buildServiceCard(services[4], false),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 2.0,
              child: _buildServiceCard(services[5], true),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.0,
              child: _buildServiceCard(services[6], false),
            ),

            // Row 5: Large Square (L) + Medium (R)
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.2,
              child: _buildServiceCard(services[7], true),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.2,
              child: _buildServiceCard(services[8], false),
            ),

            // Row 6: Full Width (Bottom)
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 0.6,
              child: _buildServiceCard(services[9], false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard(Service service, bool isTall) {
    final isSelected = _selectedId == service.id;

    return GestureDetector(
      onTap: () => _handleTap(service),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isTall ? 20 : 12),
        decoration: BoxDecoration(
          color: isSelected ? service.color.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? service.color : Colors.grey.shade100,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? service.color.withOpacity(0.1)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isSelected ? 20 : 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isTall ? 48 : 32,
              height: isTall ? 48 : 32,
              decoration: BoxDecoration(
                color: service.color.shade500,
                borderRadius: BorderRadius.circular(isTall ? 14 : 8),
              ),
              child: Icon(
                service.icon,
                color: Colors.white,
                size: isTall ? 24 : 16,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    service.tamilName,
                    style: TextStyle(
                      fontSize: isTall ? 14 : 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandDark,
                      height: 1.1,
                    ),
                    maxLines: isTall ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.brandSlate,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
