// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/components/buttons.dart';
import 'package:flutter_posresto_app/core/components/custom_text_field.dart';
import 'package:flutter_posresto_app/core/components/spaces.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/core/utils/date_formatter.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:google_fonts/google_fonts.dart'; // NEW: Google Fonts

import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/status_table/status_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/get_table/get_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/update_table/update_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/models/draft_order_model.dart';

import '../pages/payment_table_page.dart';

class TableWidget extends StatefulWidget {
  final TableModel table;
  const TableWidget({
    super.key,
    required this.table,
  });

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  TextEditingController? tableNameController;
  DraftOrderModel? data;
  @override
  void initState() {
    super.initState();
    loadData();
    tableNameController = TextEditingController(text: widget.table.tableName);
  }

  @override
  void dispose() {
    tableNameController!.dispose();
    super.dispose();
  }

  loadData() async {
    if (widget.table.status != 'available' && widget.table.orderId != null) {
      data = await ProductLocalDatasource.instance
          .getDraftOrderById(widget.table.orderId!);
    }
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.table.status == 'available') {
          context.push(DashboardPage(
            table: widget.table,
          ));
        }
      },
      onLongPress: () {
        // 1. INFO DIALOG
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Detail Meja',
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.grey),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Table Name & Edit
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.table.tableName,
                                style: GoogleFonts.quicksand(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              BlocListener<UpdateTableBloc, UpdateTableState>(
                                listener: (context, state) {
                                  state.maybeWhen(
                                      orElse: () {},
                                      success: (message) {
                                        context
                                            .read<GetTableBloc>()
                                            .add(const GetTableEvent.getTables());
                                        context.pop(); // Pop Update Dialog
                                      });
                                },
                                child: IconButton(
                                  onPressed: () {
                                    // 2. UPDATE DIALOG
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          backgroundColor: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(maxWidth: 400),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Header
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                                  decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Ubah Nama Meja',
                                                        style: GoogleFonts.quicksand(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        icon: const Icon(Icons.close, color: Colors.grey),
                                                        style: IconButton.styleFrom(
                                                          backgroundColor: Colors.grey[100],
                                                          padding: const EdgeInsets.all(8),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                
                                                // Content
                                                Padding(
                                                  padding: const EdgeInsets.all(24),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      CustomTextField(
                                                        controller: tableNameController!,
                                                        label: 'Nama Meja Baru',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                
                                                // Actions
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          style: TextButton.styleFrom(
                                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'Batal',
                                                            style: GoogleFonts.quicksand(
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            final newData = TableModel(
                                                              id: widget.table.id,
                                                              name: tableNameController!.text,
                                                              status: widget.table.status,
                                                              capacity: widget.table.capacity,
                                                            );
                                                            context.read<UpdateTableBloc>().add(
                                                              UpdateTableEvent.updateTable(newData),
                                                            );
                                                            Navigator.pop(context); // Close Update Dialog
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: AppColors.primary,
                                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'Simpan',
                                                            style: GoogleFonts.quicksand(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit, size: 20),
                                  color: Colors.grey[400],
                                  style: IconButton.styleFrom(
                                    padding: const EdgeInsets.all(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Status Badge
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: widget.table.status == 'available' 
                                  ? AppColors.primary.withOpacity(0.1) 
                                  : AppColors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: widget.table.status == 'available' 
                                    ? AppColors.primary.withOpacity(0.2) 
                                    : AppColors.red.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  widget.table.status == 'available' ? Icons.check_circle : Icons.cancel,
                                  color: widget.table.status == 'available' ? AppColors.primary : AppColors.red,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.table.status == 'available' ? 'Available' : 'Occupied',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: widget.table.status == 'available' ? AppColors.primary : AppColors.red,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close Info Dialog
                                      _showChangeStatusDialog(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: widget.table.status == 'available' ? AppColors.primary : AppColors.red,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Ubah Status',
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          if (widget.table.status != 'available') ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                children: [
                                  if (widget.table.occupiedAt != null)
                                    _buildDetailRow(Icons.access_time, 'Mulai', DateFormatter.formatDateTime2(widget.table.occupiedAt!.toIso8601String())),
                                  if (widget.table.occupiedAt != null)
                                    const SizedBox(height: 8),
                                  _buildDetailRow(Icons.receipt_long, 'Order ID', '#${widget.table.orderId}'),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Actions
                    if (widget.table.status != 'available')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: BlocConsumer<StatusTableBloc, StatusTableState>(
                          listener: (context, state) {
                            state.maybeWhen(
                                orElse: () {},
                                success: () {
                                  context
                                      .read<GetTableBloc>()
                                      .add(const GetTableEvent.getTables());
                                  context.pop();
                                });
                          },
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.pop();
                                  if (data != null) {
                                    context.read<CheckoutBloc>().add(
                                          CheckoutEvent.loadDraftOrder(data!),
                                        );
                                    context.push(PaymentTablePage(
                                      table: widget.table,
                                      draftOrder: data!,
                                    ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Selesaikan Pesanan',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },



      child: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.table.status == 'available'
              ? Colors.white
              : widget.table.status == 'reserved'
                  ? Colors.orange.withOpacity(0.1)
                  : AppColors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.table.status == 'available'
                ? Colors.grey[200]!
                : widget.table.status == 'reserved'
                    ? Colors.orange
                    : AppColors.red,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_restaurant,
              size: 40,
              color: widget.table.status == 'available'
                  ? Colors.grey[400]
                  : widget.table.status == 'reserved'
                      ? Colors.orange
                      : AppColors.red,
            ),
            const SizedBox(height: 8),
            Text(
              widget.table.tableName,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.table.capacity} Seats',
              style: GoogleFonts.quicksand(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeStatusDialog(BuildContext context) {
    String selectedStatus = widget.table.status;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ubah Status Meja',
                            style: GoogleFonts.quicksand(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.grey),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatusCard(
                                  label: 'Available',
                                  value: 'available',
                                  groupValue: selectedStatus,
                                  icon: Icons.check_circle_outline,
                                  color: AppColors.primary,
                                  onTap: () => setState(() => selectedStatus = 'available'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatusCard(
                                  label: 'Occupied',
                                  value: 'occupied',
                                  groupValue: selectedStatus,
                                  icon: Icons.cancel_outlined,
                                  color: AppColors.red,
                                  onTap: () => setState(() => selectedStatus = 'occupied'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildStatusCard(
                            label: 'Reserved',
                            value: 'reserved',
                            groupValue: selectedStatus,
                            icon: Icons.bookmark_border,
                            color: Colors.orange,
                            onTap: () => setState(() => selectedStatus = 'reserved'),
                          ),
                        ],
                      ),
                    ),
                    
                    // Actions
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Batal',
                                style: GoogleFonts.quicksand(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: BlocConsumer<StatusTableBloc, StatusTableState>(
                              listener: (context, state) {
                                state.maybeWhen(
                                  orElse: () {},
                                  success: () {
                                    context.read<GetTableBloc>().add(const GetTableEvent.getTables());
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: () {
                                    final newTable = TableModel(
                                      id: widget.table.id,
                                      name: widget.table.tableName,
                                      status: selectedStatus,
                                      capacity: widget.table.capacity,
                                      orderId: widget.table.orderId,
                                      occupiedAt: widget.table.occupiedAt,
                                    );
                                    context.read<StatusTableBloc>().add(
                                      StatusTableEvent.statusTabel(newTable),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: state.maybeWhen(
                                    orElse: () => Text(
                                      'Simpan',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    loading: () => const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusCard({
    required String label,
    required String value,
    required String groupValue,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                shape: BoxShape.circle,
                border: isSelected ? null : Border.all(color: Colors.grey[300]!),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[400],
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.quicksand(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

