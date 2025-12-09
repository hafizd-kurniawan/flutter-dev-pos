import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/components/custom_date_picker.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/core/extensions/date_time_ext.dart';
import 'package:flutter_posresto_app/core/utils/date_formatter.dart';
import 'package:flutter_posresto_app/presentation/report/blocs/item_sales_report/item_sales_report_bloc.dart';
import 'package:flutter_posresto_app/presentation/report/blocs/product_sales/product_sales_bloc.dart';
import 'package:flutter_posresto_app/presentation/report/blocs/summary/summary_bloc.dart';
import 'package:flutter_posresto_app/presentation/report/blocs/transaction_report/transaction_report_bloc.dart';
import 'package:flutter_posresto_app/presentation/report/widgets/item_sales_report_widget.dart';
import 'package:flutter_posresto_app/presentation/report/widgets/product_sales_chart_widget.dart';
import 'package:flutter_posresto_app/presentation/report/widgets/report_menu.dart';
import 'package:flutter_posresto_app/presentation/report/widgets/report_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/presentation/report/widgets/summary_report_widget.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';
import 'package:flutter_posresto_app/presentation/report/widgets/transaction_report_widget.dart';

import '../../../core/components/spaces.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int selectedMenu = 0;
  String title = 'Summary Sales Report'; // Initial title, will be updated by localization in build if needed, but state holds the key logic.
  // Better to initialize in initState or build if we want it localized immediately on first load.
  // However, for now, let's just ensure the UI uses localized strings.
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String searchDateFormatted =
        '${fromDate.toFormattedDate2()} to ${toDate.toFormattedDate2()}';
    return Scaffold(
      body: Row(
        children: [
          // LEFT CONTENT
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReportTitle(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                        Expanded(
                          child: CustomDatePicker(
                            prefix: Text('${AppLocalizations.of(context)!.from}: '),
                            initialDate: fromDate,
                            onDateSelected: (selectedDate) {
                              fromDate = selectedDate;
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomDatePicker(
                            label: AppLocalizations.of(context)!.end_date,
                            initialDate: toDate,
                              //               DateFormatter.formatDateTime(
                              //                   fromDate),
                              //           endDate: DateFormatter.formatDateTime(
                              //               toDate)),
                              //     );
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Wrap(
                        children: [
                          ReportMenu(
                            label: AppLocalizations.of(context)!.transaction_report,
                            onPressed: () {
                              selectedMenu = 0;
                              title: AppLocalizations.of(context)!.transaction_report;
                              setState(() {});
                              //enddate is 1 month before the current date
                              context.read<TransactionReportBloc>().add(
                                    TransactionReportEvent.getReport(
                                        startDate: DateFormatter.formatDateTime(
                                            fromDate),
                                        endDate: DateFormatter.formatDateTime(
                                            toDate)),
                                  );
                            },
                            isActive: selectedMenu == 0,
                          ),
                          ReportMenu(
                            label: AppLocalizations.of(context)!.item_sales_report,
                            onPressed: () {
                              selectedMenu = 1;
                              title: AppLocalizations.of(context)!.item_sales_report;
                              setState(() {});
                              context.read<ItemSalesReportBloc>().add(
                                    ItemSalesReportEvent.getItemSales(
                                        startDate: DateFormatter.formatDateTime(
                                            fromDate),
                                        endDate: DateFormatter.formatDateTime(
                                            toDate)),
                                  );
                            },
                            isActive: selectedMenu == 1,
                          ),
                          ReportMenu(
                            label: AppLocalizations.of(context)!.product_sales_chart,
                            onPressed: () {
                              selectedMenu = 2;
                              title: AppLocalizations.of(context)!.product_sales_chart;
                              setState(() {});
                              context.read<ProductSalesBloc>().add(
                                    ProductSalesEvent.getProductSales(
                                        DateFormatter.formatDateTime(fromDate),
                                        DateFormatter.formatDateTime(toDate)),
                                  );
                            },
                            isActive: selectedMenu == 2,
                          ),
                          ReportMenu(
                            label: AppLocalizations.of(context)!.summary_sales_report,
                            onPressed: () {
                              selectedMenu = 3;
                              title: AppLocalizations.of(context)!.summary_sales_report;
                              setState(() {});
                              context.read<SummaryBloc>().add(
                                    SummaryEvent.getSummary(
                                        DateFormatter.formatDateTime(fromDate),
                                        DateFormatter.formatDateTime(toDate)),
                                  );

                              log("Date ${DateFormatter.formatDateTime(fromDate)}");
                            },
                            isActive: selectedMenu == 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // RIGHT CONTENT
          Expanded(
              flex: 2,
              child: selectedMenu == 0
                  ? BlocBuilder<TransactionReportBloc, TransactionReportState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (message) {
                            return Text(message);
                          },
                          loaded: (transactionReport) {
                            return TransactionReportWidget(
                              transactionReport: transactionReport,
                              title: title,
                              searchDateFormatted: searchDateFormatted,
                              headerWidgets: _getTitleReportPageWidget(),
                            );
                          },
                        );
                      },
                    )
                  : selectedMenu == 1
                      ? BlocBuilder<ItemSalesReportBloc, ItemSalesReportState>(
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (message) {
                                return Text(message);
                              },
                              loaded: (itemSales) {
                                return ItemSalesReportWidget(
                                  itemSales: itemSales,
                                  title: title,
                                  searchDateFormatted: searchDateFormatted,
                                  headerWidgets: _getItemSalesPageWidget(),
                                );
                              },
                            );
                          },
                        )
                      : selectedMenu == 2
                          ? BlocBuilder<ProductSalesBloc, ProductSalesState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (message) {
                                    return Text(message);
                                  },
                                  success: (productSales) {
                                    return ProductSalesChartWidgets(
                                      title: title,
                                      searchDateFormatted: searchDateFormatted,
                                      productSales: productSales,
                                    );
                                  },
                                );
                              },
                            )
                          : BlocBuilder<SummaryBloc, SummaryState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  error: (message) {
                                    return Text(message);
                                  },
                                  success: (summary) {
                                    return SummaryReportWidget(
                                      summary: summary,
                                      title: title,
                                      searchDateFormatted: searchDateFormatted,
                                    );
                                  },
                                );
                              },
                            )),
        ],
      ),
    );
  }

  List<Widget> _getTitleReportPageWidget() {
    return [
      _getTitleItemWidget(AppLocalizations.of(context)!.id_col, 120),
      _getTitleItemWidget(AppLocalizations.of(context)!.total_col, 100),
      _getTitleItemWidget(AppLocalizations.of(context)!.sub_total_col, 100),
      _getTitleItemWidget(AppLocalizations.of(context)!.tax_col, 100),
      _getTitleItemWidget(AppLocalizations.of(context)!.discount_col, 100),
      _getTitleItemWidget(AppLocalizations.of(context)!.service_col, 100),
      _getTitleItemWidget(AppLocalizations.of(context)!.total_item_col, 100),
      _getTitleItemWidget(AppLocalizations.of(context)!.cashier_col, 180),
      _getTitleItemWidget(AppLocalizations.of(context)!.time_col, 200),
    ];
  }

  List<Widget> _getItemSalesPageWidget() {
    return [
      _getTitleItemWidget(AppLocalizations.of(context)!.id_col, 80),
      _getTitleItemWidget(AppLocalizations.of(context)!.order_col, 60),
      _getTitleItemWidget(AppLocalizations.of(context)!.product_col, 160),
      _getTitleItemWidget(AppLocalizations.of(context)!.qty_col, 60),
      _getTitleItemWidget(AppLocalizations.of(context)!.price_col, 140),
      _getTitleItemWidget(AppLocalizations.of(context)!.total_price_col, 140),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      color: AppColors.primary,
      alignment: Alignment.centerLeft,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
