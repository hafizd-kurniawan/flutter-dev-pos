import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/core/extensions/date_time_ext.dart';
import 'package:flutter_posresto_app/presentation/sales/blocs/day_sales/day_sales_bloc.dart';

import '../widgets/sales_widget.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  void initState() {
    context.read<DaySalesBloc>().add(DaySalesEvent.getDaySales(DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.app_name,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${DateTime.now().toFormattedDate()}",
                style: const TextStyle(
                  color: AppColors.subtitle,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Expanded(
            child: BlocBuilder<DaySalesBloc, DaySalesState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loaded: (orders) {
                    log("message: ${orders.length}");
                    if (orders.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_transactions,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return SalesWidget(
                        headerWidgets: _getTitleHeaderWidget(),
                        orders: orders,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getTitleHeaderWidget() {
    return [
      _getTitleItemWidget(AppLocalizations.of(context)!.id_col, 40),
      _getTitleItemWidget(AppLocalizations.of(context)!.customer_col, 120),
      _getTitleItemWidget(AppLocalizations.of(context)!.status_col, 120),
      _getTitleItemWidget(AppLocalizations.of(context)!.sync_col, 60),
      _getTitleItemWidget(AppLocalizations.of(context)!.payment_status_col, 120),
      _getTitleItemWidget(AppLocalizations.of(context)!.payment_method_col, 120),
      _getTitleItemWidget(AppLocalizations.of(context)!.payment_amount_col, 120),
      _getTitleItemWidget(AppLocalizations.of(context)!.sub_total_col, 120),
      _getTitleItemWidget(AppLocalizations.of(context)!.tax_col, 120),
      _getTitleItemWidget(AppLocalizations.of(context)!.discount_col, 60),
      _getTitleItemWidget(AppLocalizations.of(context)!.service_charge_col, 120),
      _getTitleItemWidget(AppLocalizations.of(context)!.total_col, 120),
      _getTitleItemWidget(AppLocalizations.of(context)!.payment_col, 60),
      _getTitleItemWidget(AppLocalizations.of(context)!.item_col, 60),
      _getTitleItemWidget(AppLocalizations.of(context)!.cashier_col, 150),
      _getTitleItemWidget(AppLocalizations.of(context)!.time_col, 230),
      _getTitleItemWidget(AppLocalizations.of(context)!.action_col, 230),
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
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
