import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/datasources/dashboard_remote_datasource.dart';
import 'package:flutter_posresto_app/presentation/dashboard/bloc/dashboard_summary_bloc.dart';
import 'package:flutter_posresto_app/presentation/dashboard/widgets/dashboard_summary_widget.dart';

class SimpleDashboardPage extends StatelessWidget {
  const SimpleDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardSummaryBloc(DashboardRemoteDatasource())
        ..add(DashboardSummaryGetSummary()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            BlocBuilder<DashboardSummaryBloc, DashboardSummaryState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<DashboardSummaryBloc>().add(
                      DashboardSummaryGetSummary(),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: const DashboardSummaryWidget(),
      ),
    );
  }
}
