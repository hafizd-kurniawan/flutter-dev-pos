import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/components/components.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/change_position_table/change_position_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/create_table/create_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/get_table/get_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/widgets/table_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';

class TableManagementScreen extends StatefulWidget {
  const TableManagementScreen({super.key});

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  TextEditingController? tableNameController;

  @override
  void initState() {
    context.read<GetTableBloc>().add(const GetTableEvent.getTables());
    tableNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    tableNameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // final tables = ref.watch(tableProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.table_layout,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        // leading: Icon(Icons.arrow_back),
        backgroundColor: AppColors.white,
        actions: [
          BlocListener<CreateTableBloc, CreateTableState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  success: (message) {
                    context
                        .read<GetTableBloc>()
                        .add(const GetTableEvent.getTables());
                  });
            },
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // show dialaog adn input table name
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.add_table),
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
                                    label: AppLocalizations.of(context)!.table_name_input,
                                  ),
                                  SpaceHeight(16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Button.outlined(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          label: AppLocalizations.of(context)!.close,
                                        ),
                                      ),
                                      SpaceWidth(16),
                                      Expanded(
                                        child: Button.filled(
                                          onPressed: () {
                                            context.read<CreateTableBloc>().add(
                                                CreateTableEvent.createTable(
                                                    tableNameController!.text,
                                                    Offset(200, 200)));
                                            context
                                                .pop(); // close dialog after adding
                                          },
                                          label: AppLocalizations.of(context)!.add,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          actions: []);
                    });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Handle delete action
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Handle delete action
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Handle delete action
            },
          ),
          SpaceWidth(16),
        ],
      ),
      body: BlocBuilder<GetTableBloc, GetTableState>(
        builder: (context, state) {
          return state.maybeWhen(orElse: () {
            return Container();
          }, success: (tables, categories) {
            return Stack(
              children: tables.map((table) {
                return Positioned(
                  left: table.position.dx - 116,
                  top: table.position.dy - 80,
                  child: BlocListener<ChangePositionTableBloc,
                      ChangePositionTableState>(
                    listener: (context, state) {
                      state.maybeWhen(
                          orElse: () {},
                          success: (message) {
                            context
                                .read<GetTableBloc>()
                                .add(const GetTableEvent.getTables());
                          });
                    },
                    child: Draggable(
                      feedback: TableWidget(table: table),
                      childWhenDragging: SizedBox.shrink(),
                      onDragEnd: (details) {
                        context
                            .read<ChangePositionTableBloc>()
                            .add(ChangePositionTableEvent.changePositionTable(
                              tableId: table.id!,
                              position: details.offset,
                            ));
                      },
                      child: TableWidget(table: table),
                    ),
                  ),
                );
              }).toList(),
            );
          });
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => ref.read(tableProvider.notifier).addTable(),
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
