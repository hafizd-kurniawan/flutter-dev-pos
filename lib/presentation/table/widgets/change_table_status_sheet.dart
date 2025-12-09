import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/get_table/get_table_bloc.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';

class ChangeTableStatusSheet extends StatefulWidget {
  final TableModel table;

  const ChangeTableStatusSheet({
    super.key,
    required this.table,
  });

  @override
  State<ChangeTableStatusSheet> createState() => _ChangeTableStatusSheetState();
}

class _ChangeTableStatusSheetState extends State<ChangeTableStatusSheet> {
  late String _selectedStatus;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int _partySize = 2;
  bool _isLoading = false;
  bool _isUpdated = false; // Track if status was updated

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.table.status;
    _nameController.text = widget.table.customerName ?? '';
    _phoneController.text = widget.table.customerPhone ?? '';
    _partySize = widget.table.partySize ?? 2;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetTableBloc, GetTableState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (tables, _) {
            if (_isLoading) {
              setState(() {
                _isLoading = false;
                _isUpdated = true; // Mark as updated
              });
              NotificationHelper.showSuccess(context, 'Status meja berhasil diperbarui');
            }
          },
          error: (message) {
            if (_isLoading) {
              setState(() => _isLoading = false);
              NotificationHelper.showError(context, 'Gagal memperbarui status: $message');
            }
          },
          orElse: () {},
        );
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      Flexible(
                        child: Text(
                          'Ubah Status Meja',
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context, _isUpdated ? widget.table.id : null),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Selection
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatusCard(
                              label: AppLocalizations.of(context)!.status_available,
                              value: 'available',
                              groupValue: _selectedStatus,
                              icon: Icons.check_circle_outline,
                              color: AppColors.primary,
                              onTap: () => setState(() => _selectedStatus = 'available'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatusCard(
                              label: 'Occupied',
                              value: 'occupied',
                              groupValue: _selectedStatus,
                              icon: Icons.cancel_outlined,
                              color: AppColors.red,
                              onTap: () => setState(() => _selectedStatus = 'occupied'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatusCard(
                              label: 'Reserved',
                              value: 'reserved',
                              groupValue: _selectedStatus,
                              icon: Icons.bookmark_border,
                              color: Colors.orange,
                              onTap: () => setState(() => _selectedStatus = 'reserved'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatusCard(
                              label: 'Pending',
                              value: 'pending_bill',
                              groupValue: _selectedStatus,
                              icon: Icons.receipt_long,
                              color: Colors.amber,
                              onTap: () => setState(() => _selectedStatus = 'pending_bill'),
                            ),
                          ),
                        ],
                      ),

                      // Customer Details Form
                      if (_selectedStatus == 'occupied' || _selectedStatus == 'reserved') ...[
                        const SizedBox(height: 24),
                        Text(
                          'Detail Pelanggan',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Name
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nama Pelanggan${_selectedStatus == 'occupied' ? '*' : ''}',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 12),
                        
                        // Phone
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Nomor Telepon',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        
                        // Party Size
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.people_outline, color: Colors.grey[600]),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  'Jumlah Tamu',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: _partySize > 1
                                    ? () => setState(() => _partySize--)
                                    : null,
                                icon: const Icon(Icons.remove_circle_outline),
                                color: AppColors.primary,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  '$_partySize',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _partySize < widget.table.capacity
                                    ? () => setState(() => _partySize++)
                                    : null,
                                icon: const Icon(Icons.add_circle_outline),
                                color: AppColors.primary,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                          onPressed: _isLoading ? null : () => Navigator.pop(context, _isUpdated ? widget.table.id : null), // Return table ID if updated
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
                          onPressed: _isLoading ? null : _updateStatus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
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
        ),
      ),
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
        padding: const EdgeInsets.all(12),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                shape: BoxShape.circle,
                border: isSelected ? null : Border.all(color: Colors.grey[300]!),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[400],
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? color : Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.quicksand(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  void _updateStatus() {
    // Validation
    if ((_selectedStatus == 'occupied' || _selectedStatus == 'reserved') &&
        _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nama pelanggan wajib diisi',
            style: GoogleFonts.quicksand(color: Colors.white),
          ),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    context.read<GetTableBloc>().add(
      GetTableEvent.updateTableStatus(
        tableId: widget.table.id!,
        status: _selectedStatus,
        customerName: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : null,
        customerPhone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        partySize: (_selectedStatus == 'occupied' || _selectedStatus == 'reserved')
            ? _partySize
            : null,
      ),
    );
  }
}


