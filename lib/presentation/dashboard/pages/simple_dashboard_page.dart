import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/datasources/dashboard_remote_datasource.dart';
import 'package:flutter_posresto_app/presentation/dashboard/bloc/dashboard_summary_bloc.dart';
import 'package:flutter_posresto_app/presentation/dashboard/widgets/dashboard_summary_widget.dart';
import 'package:flutter_posresto_app/presentation/home/widgets/floating_header.dart';

class SimpleDashboardPage extends StatelessWidget {
  final VoidCallback? onToggleSidebar;

  const SimpleDashboardPage({
    Key? key,
    this.onToggleSidebar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardSummaryBloc(DashboardRemoteDatasource())
        ..add(DashboardSummaryGetSummary()),
      child: Scaffold(
        body: Stack(
          children: [
            // 1. Main Content
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: const DashboardSummaryWidget(),
            ),

            // 2. Floating Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: BlocBuilder<DashboardSummaryBloc, DashboardSummaryState>(
                builder: (context, state) {
                  return FloatingHeader(
                    title: 'Dashboard',
                    isSidebarVisible: true, // Assuming sidebar is always visible or handled by parent
                    onToggleSidebar: onToggleSidebar ?? () {},
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          context.read<DashboardSummaryBloc>().add(
                                DashboardSummaryGetSummary(),
                              );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
