import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/components/components.dart';
import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/data/models/response/print_model.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/create_printer/create_printer_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/get_printer_kitchen/get_printer_kitchen_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/update_printer/update_printer_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/widgets/dialog_search_printer.dart';

class KitchenPrinterPage extends StatefulWidget {
  const KitchenPrinterPage({super.key});

  @override
  State<KitchenPrinterPage> createState() => _KitchenPrinterPageState();
}

class _KitchenPrinterPageState extends State<KitchenPrinterPage> {
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
    context.read<GetPrinterKitchenBloc>().add(GetPrinterKitchenEvent.get());
  }

  @override
  void dispose() {
    addressController!.dispose();
    printNameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<GetPrinterKitchenBloc, GetPrinterKitchenState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () {
                return const Center(child: CircularProgressIndicator());
              },
              loading: () {
                return Center(child: CircularProgressIndicator());
              },
              success: (data) {
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
                      const Text(
                        'Kitchen Printer',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SpaceHeight(16),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Printer Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        value: selectedPrinter, // nilai default
                        items: const [
                          DropdownMenuItem(
                            value: 'Bluetooth',
                            child: Text('Bluetooth'),
                          ),
                          DropdownMenuItem(
                            value: 'Network',
                            child: Text('Network'),
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
                              label: 'Search')
                          : CustomTextField(
                              controller: addressController!,
                              label: 'Address',
                              showLabel: false,
                            ),
                      SpaceHeight(16),
                      // Textfield for name
                      CustomTextField(
                        controller: printNameController!,
                        label: 'Print Name',
                        showLabel: false,
                      ),
                      SpaceHeight(16),
                      // Textfield for width paper
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Width Paper',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        value: paper, // nilai default
                        items: const [
                          DropdownMenuItem(
                            value: '58',
                            child: Text('58 mm'),
                          ),
                          DropdownMenuItem(
                            value: '80',
                            child: Text('80 mm'),
                          ),
                        ],
                        onChanged: (value) {
                          paper = value ?? '58';
                          log('Paper : $paper');
                        },
                      ),

                      SpaceHeight(16),
                      // button test print
                      Button.outlined(onPressed: () {}, label: 'Test Print'),
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
                                        .read<GetPrinterKitchenBloc>()
                                        .add(GetPrinterKitchenEvent.get());
                                  },
                                  error: (message) {
                                    NotificationHelper.showError(context, message);
                                  },
                                );
                              },
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () {
                                    return Button.filled(
                                      onPressed: () {
                                        final printData = PrintModel(
                                          code: 'kitchen',
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
                                      label: 'Save',
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
                                        .read<GetPrinterKitchenBloc>()
                                        .add(GetPrinterKitchenEvent.get());
                                  },
                                  error: (message) {
                                    NotificationHelper.showError(context, message);
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
                                          code: 'kitchen',
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
                                      label: 'Save',
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
