import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';

class TableInfoCard extends StatelessWidget {
  final TableModel table;
  final VoidCallback onTap;
  final bool isHighlighted; // NEW: Highlight recently updated table

  const TableInfoCard({
    super.key,
    required this.table,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500), // Slower animation for visibility
        padding: const EdgeInsets.all(10), // Reduced padding
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted ? Colors.green : Colors.transparent,
            width: isHighlighted ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: isHighlighted 
                  ? Colors.green.withOpacity(0.4) 
                  : Colors.black.withOpacity(0.05),
              blurRadius: isHighlighted ? 12 : 8,
              spreadRadius: isHighlighted ? 2 : 0, // Spread shadow when highlighted
              offset: Offset(0, isHighlighted ? 0 : 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header: Status Icon + Name
            Row(
              children: [
                Icon(
                  _getStatusIcon(table.status),
                  size: 16,
                  color: _getStatusColor(table.status),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    table.name,
                    style: const TextStyle(
                      fontSize: 15, // Slightly smaller
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            // Category & Capacity
            Row(
              children: [
                if (table.categoryName != null) ...[
                  Icon(Icons.category_outlined, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      table.categoryName!,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Icon(Icons.people_outline, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 2),
                Text(
                  '${table.capacity}p',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
            
            const SizedBox(height: 6),
            
            // Status-specific info (Customer, Phone, etc.)
            Expanded(
              child: _buildStatusInfo(),
            ),
            
            const SizedBox(height: 4),
            
            // Status Badge
            _buildStatusBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo() {
    switch (table.status) {
      case 'occupied':
      case 'reserved':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (table.customerName != null && table.customerName!.isNotEmpty) ...[
              // Customer Name
              Row(
                children: [
                  Icon(Icons.person, size: 12, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      table.customerName!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              // Phone Number (New)
              if (table.customerPhone != null && table.customerPhone!.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.phone, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        table.customerPhone!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            ] else
              Text(
                table.status == 'reserved' ? 'Reserved' : 'Occupied',
                style: TextStyle(
                  fontSize: 11,
                  color: _getStatusColor(table.status),
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        );
      
      case 'pending_bill':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (table.customerName != null && table.customerName!.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.person, size: 12, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      table.customerName!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            Text(
              'Waiting payment',
              style: TextStyle(
                fontSize: 11,
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      
      default: // available
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Ready to serve',
            style: TextStyle(
              fontSize: 11,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
    }
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(table.status).withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _getStatusColor(table.status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: _getStatusText(table.status)),
                  if (table.status == 'occupied' && table.occupiedAt != null)
                    TextSpan(
                      text: ' • ${_getDuration(table.occupiedAt!)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                ],
              ),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(table.status),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'occupied':
        return Colors.red;
      case 'reserved':
        return Colors.orange;
      case 'pending_bill':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'available':
        return Icons.check_circle;
      case 'occupied':
        return Icons.people;
      case 'reserved':
        return Icons.event;
      case 'pending_bill':
        return Icons.receipt;
      default:
        return Icons.table_restaurant;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'available':
        return 'Available';
      case 'occupied':
        return 'Occupied';
      case 'reserved':
        return 'Reserved';
      case 'pending_bill':
        return 'Pending Bill';
      default:
        return status.toUpperCase();
    }
  }

  String _getDuration(DateTime startTime) {
    final duration = DateTime.now().difference(startTime);
    
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
