import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';

class TableInfoCard extends StatelessWidget {
  final TableModel table;
  final VoidCallback onTap;
  final bool isHighlighted; // NEW: Highlight recently updated table

  const TableInfoCard({
    Key? key,
    required this.table,
    required this.onTap,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.green.shade50 : Colors.white, // Highlight background
          borderRadius: BorderRadius.circular(16), // Increased radius
          border: Border.all(
            color: isHighlighted ? Colors.green : Colors.transparent, // Removed grey border for cleaner look
            width: isHighlighted ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: isHighlighted 
                  ? Colors.green.withOpacity(0.3) 
                  : Colors.black.withOpacity(0.05), // Subtle shadow
              blurRadius: isHighlighted ? 8 : 10,
              offset: Offset(0, isHighlighted ? 2 : 4),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (table.occupiedAt != null && table.status == 'occupied')
                  const SizedBox.shrink(), // Placeholder
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Category & Capacity
            if (table.categoryName != null) ...[
              Row(
                children: [
                  Icon(Icons.category, size: 11, color: Colors.grey[600]),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      table.categoryName!,
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
              const SizedBox(height: 3),
            ],
            
            Row(
              children: [
                Icon(Icons.people, size: 11, color: Colors.grey[600]),
                const SizedBox(width: 3),
                Text(
                  '${table.capacity}p',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Status-specific info
            Expanded(
              child: _buildStatusInfo(),
            ),
            
            const SizedBox(height: 6),
            
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
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                        children: [
                          TextSpan(
                            text: table.customerName!,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if (table.partySize != null)
                            TextSpan(
                              text: ' • ${table.partySize}/${table.capacity}',
                              style: TextStyle(color: Colors.grey[600], fontSize: 10),
                            ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else if (table.partySize != null)
              Text(
                '${table.partySize} / ${table.capacity} guests',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        );
      
      case 'reserved':
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
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                        children: [
                          TextSpan(
                            text: table.customerName!,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if (table.partySize != null)
                            TextSpan(
                              text: ' • ${table.partySize}p',
                              style: TextStyle(color: Colors.grey[600], fontSize: 10),
                            ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else
              Text(
                'Reserved',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.orange[700],
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
                        fontSize: 11,
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
                fontSize: 10,
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
              fontSize: 10,
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
