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

import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/status_table/status_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/create_table/create_table_bloc.dart';
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
        // dialog info table
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.table_bar, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Table ${widget.table.tableName}'),
                  Spacer(),
                  BlocListener<UpdateTableBloc, UpdateTableState>(
                    listener: (context, state) {
                      state.maybeWhen(
                          orElse: () {},
                          success: (message) {
                            context
                                .read<GetTableBloc>()
                                .add(const GetTableEvent.getTables());
                            context.pop();
                          });
                    },
                    child: IconButton(
                        onPressed: () {
                          // show dialaog adn input table name
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text('Update Table'),
                                    content: SingleChildScrollView(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: 180,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomTextField(
                                              controller: tableNameController!,
                                              label: 'Table Name',
                                            ),
                                            SpaceHeight(16),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Button.outlined(
                                                    onPressed: () {
                                                      context.pop();
                                                    },
                                                    label: 'close',
                                                  ),
                                                ),
                                                SpaceWidth(16),
                                                Expanded(
                                                  child: Button.filled(
                                                    onPressed: () {
                                                      final newData =
                                                          TableModel(
                                                        id: widget.table.id,
                                                        name:
                                                            tableNameController!
                                                                .text,
                                                        status:
                                                            widget.table.status,
                                                        capacity: widget.table.capacity,
                                                      );
                                                      context
                                                          .read<
                                                              UpdateTableBloc>()
                                                          .add(
                                                            UpdateTableEvent
                                                                .updateTable(
                                                              newData,
                                                            ),
                                                          );
                                                      context
                                                          .pop(); // close dialog after adding
                                                    },
                                                    label: 'Update',
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: []);
                              });
                        },
                        icon: Icon(Icons.edit)),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                      'Status:',
                      widget.table.status == 'available'
                          ? 'Available'
                          : 'Occupied',
                      color: widget.table.status == 'available'
                          ? Colors.green
                          : Colors.red),
                  widget.table.status == 'available'
                      ? SizedBox.shrink()
                      : widget.table.occupiedAt != null
                          ? _buildInfoRow(
                              'Start Time:',
                              DateFormatter.formatDateTime2(
                                  widget.table.occupiedAt!.toIso8601String()))
                          : const SizedBox.shrink(),
                  widget.table.status == 'available'
                      ? SizedBox.shrink()
                      : _buildInfoRow(
                          'Order ID:', widget.table.orderId.toString()),
                  widget.table.status == 'available'
                      ? SizedBox.shrink()
                      : SpaceHeight(16),
                  widget.table.status == 'available'
                      ? SizedBox.shrink()
                      : BlocConsumer<StatusTableBloc, StatusTableState>(
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
                            return Button.filled(
                                onPressed: () {
                                  // final newTable = TableModel(
                                  //   id: widget.table!.id,
                                  //   tableName: widget.table!.tableName,
                                  //   status: 'available',
                                  //   orderId: 0,
                                  //   paymentAmount: 0,
                                  //   startTime: DateTime.now().toIso8601String(),
                                  //   position: widget.table!.position,
                                  // );
                                  // context.read<StatusTableBloc>().add(
                                  //       StatusTableEvent.statusTabel(
                                  //         newTable,
                                  //       ),
                                  //     );
                                  context.pop();
                                  context.read<CheckoutBloc>().add(
                                        CheckoutEvent.loadDraftOrder(data!),
                                      );
                                  context.push(PaymentTablePage(
                                    table: widget.table,
                                    draftOrder: data!,
                                  ));
                                },
                                label: 'Selesai');
                          },
                        )
                ],
              ),
              actions: [
                TextButton(
                  child:
                      Text('Close', style: TextStyle(color: AppColors.primary)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.table.status == 'available'
              ? AppColors.primary
              : AppColors.red,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('${widget.table.tableName}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
