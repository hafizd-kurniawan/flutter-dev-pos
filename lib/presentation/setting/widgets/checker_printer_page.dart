import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/components/components.dart';
import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/data/models/response/print_model.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/create_printer/create_printer_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/get_printer_checker/get_printer_checker_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/update_printer/update_printer_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/widgets/dialog_search_printer.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';

class CheckerPrinterPage extends StatefulWidget {
  const CheckerPrinterPage({super.key});

  @override
  State<CheckerPrinterPage> createState() => _CheckerPrinterPageState();
}

class _CheckerPrinterPageState extends State<CheckerPrinterPage> {
  String selectedPrinter = 'Bluetooth';
  TextEditingController? addressController;
  TextEditingController? printNameController;
  String paper = '58';
  bool isInitialized = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressController = TextEditingController();
    printNameController = TextEditingController();
    context.read<GetPrinterCheckerBloc>().add(GetPrinterCheckerEvent.get());
  }

  @override
  void dispose() {
    addressController!.dispose();
    printNameController!.dispose();
    isInitialized = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<GetPrinterCheckerBloc, GetPrinterCheckerState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () {
                return SizedBox.shrink();
              },
              loading: () {
                return Center(child: CircularProgressIndicator());
              },
              success: (data) {
                log("Checker Printer: ${data?.toMap()}");
                if (data != null && !isInitialized) {
                  addressController!.text = data.address;
                  printNameController!.text = data.name;
                  selectedPrinter = data.type;
                  paper = data.paper;
                  isInitialized = true;
                }
                return Container(
                  // width: 300,
                  width: context.deviceWidth,
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: ListView(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.checker_printer_title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SpaceHeight(16),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.printer_type,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        value: selectedPrinter, // nilai default
                        items: [
                          DropdownMenuItem(
                            value: 'Bluetooth',
                            child: Text(AppLocalizations.of(context)!.bluetooth),
                          ),
                          DropdownMenuItem(
                            value: 'Network',
                            child: Text(AppLocalizations.of(context)!.network),
                          ),
                        ],
                        onChanged: (value) {
                          selectedPrinter = value ?? 'Bluetooth';
                          setState(() {});
                        },
                      ),
                      SpaceHeight(8),
                      //button search
                      selectedPrinter == 'Bluetooth'
                          ? Button.outlined(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => DialogSearchPrinter(
                                    onSelected: (value) {
                                      addressController!.text = value;
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                              label: AppLocalizations.of(context)!.search_generic)
                          : CustomTextField(
                              controller: addressController!,
                              label: AppLocalizations.of(context)!.printer_address,
                              showLabel: false,
                            ),
                      SpaceHeight(16),
                      // Textfield for name
                      CustomTextField(
                        controller: printNameController!,
                        label: AppLocalizations.of(context)!.printer_name,
                        showLabel: false,
                      ),
                      SpaceHeight(16),
                      // Textfield for width paper
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.paper_width,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        value: paper, // nilai default
                        items: [
                          DropdownMenuItem(
                            value: '58',
                            child: Text(AppLocalizations.of(context)!.size_58mm),
                          ),
                          DropdownMenuItem(
                            value: '80',
                            child: Text(AppLocalizations.of(context)!.size_80mm),
                          ),
                        ],
                        onChanged: (value) {
                          paper = value ?? '58';
                          log('Paper : $paper');
                        },
                      ),

                      SpaceHeight(16),
                      // button test print
                      Button.outlined(onPressed: () {}, label: AppLocalizations.of(context)!.test_print),
                      SpaceHeight(8),
                      // button save
                      data == null
                          ? BlocConsumer<CreatePrinterBloc, CreatePrinterState>(
                              listener: (context, state) {
                                state.maybeWhen(
                                  orElse: () {},
                                  success: (message) {
                                    NotificationHelper.showSuccess(context, message);
                                    context
                                        .read<GetPrinterCheckerBloc>()
                                        .add(GetPrinterCheckerEvent.get());
                                  },
                                );
                              },
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () {
                                    return Button.filled(
                                      onPressed: () {
                                        final printData = PrintModel(
                                          code: 'checker',
                                          name: printNameController!.text,
                                          address: addressController!.text,
                                          paper: paper,
                                          type: selectedPrinter,
                                        );

                                        context.read<CreatePrinterBloc>().add(
                                              CreatePrinterEvent.createPrinter(
                                                  printData),
                                            );
                                      },
                                      label: AppLocalizations.of(context)!.save,
                                    );
                                  },
                                  loading: () {
                                    return CircularProgressIndicator();
                                  },
                                );
                              },
                            )
                          : BlocConsumer<UpdatePrinterBloc, UpdatePrinterState>(
                              listener: (context, state) {
                                state.maybeWhen(
                                  orElse: () {},
                                  success: (message) {
                                    NotificationHelper.showSuccess(context, message);
                                    context
                                        .read<GetPrinterCheckerBloc>()
                                        .add(GetPrinterCheckerEvent.get());
                                  },
                                );
                              },
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () {
                                    return Button.filled(
                                      onPressed: () {
                                        final printData = PrintModel(
                                          id: data.id,
                                          code: 'checker',
                                          name: printNameController!.text,
                                          address: addressController!.text,
                                          paper: paper,
                                          type: selectedPrinter,
                                        );
                                        log("Print Data : ${printData.toMap()}");

                                        context.read<UpdatePrinterBloc>().add(
                                              UpdatePrinterEvent.updatePrinter(
                                                printData,
                                              ),
                                            );
                                      },
                                      label: AppLocalizations.of(context)!.save,
                                    );
                                  },
                                  loading: () {
                                    return CircularProgressIndicator();
                                  },
                                );
                              },
                            ),
                      SpaceHeight(16),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}
