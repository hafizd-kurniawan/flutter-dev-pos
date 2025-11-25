import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_posresto_app/data/dataoutputs/laman_print.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/category_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/discount_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/midtrans_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/pos_settings_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/order_item_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/table_remote_datasource.dart';
import 'package:flutter_posresto_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/pos_settings/pos_settings_bloc.dart';
import 'package:flutter_posresto_app/presentation/auth/login_page.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/category/category_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/get_table_status/get_table_status_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/online_checker/online_checker_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/qris/qris_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/status_table/status_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/presentation/report/blocs/item_sales_report/item_sales_report_bloc.dart';
import 'package:flutter_posresto_app/presentation/report/blocs/product_sales/product_sales_bloc.dart';
import 'package:flutter_posresto_app/presentation/report/blocs/summary/summary_bloc.dart';
import 'package:flutter_posresto_app/presentation/sales/blocs/bloc/last_order_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/sales/blocs/day_sales/day_sales_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/create_printer/create_printer_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/get_categories/get_categories_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/get_printer_bar/get_printer_bar_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/get_printer_checker/get_printer_checker_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/get_printer_kitchen/get_printer_kitchen_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/get_printer_receipt/get_printer_receipt_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/update_printer/update_printer_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/change_position_table/change_position_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/create_table/create_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/generate_table/generate_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/get_table/get_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/local_product/local_product_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/order/order_bloc.dart';
import 'package:flutter_posresto_app/presentation/report/blocs/transaction_report/transaction_report_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_product/sync_product_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/update_table/update_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/pages/new_table_management_page.dart';
import 'package:flutter_posresto_app/presentation/history/bloc/history/history_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:imin_printer/imin_printer.dart';

import 'core/constants/colors.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/home/pages/dashboard_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await LamanPrint.init();
  // final dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);
  // Hive.registerAdapter(TableDataAdapter());
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  // final iminPrinter = IminPrinter();
  String version = '1.0.0';
  @override
  void initState() {
    super.initState();
    getSdkVersion();
  }

  Future<void> getSdkVersion() async {
    // final sdkVersion = await iminPrinter.getSdkVersion();
    if (!mounted) return;
    // setState(() {
    //   version = sdkVersion!;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SyncProductBloc(ProductRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              LocalProductBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SyncOrderBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => TransactionReportBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CreateTableBloc(),
        ),
        BlocProvider(
          create: (context) => ChangePositionTableBloc(),
        ),
        BlocProvider(
          create: (context) => GetTableBloc(TableRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => UpdateTableBloc(),
        ),
        BlocProvider(
          create: (context) => StatusTableBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) =>
              LastOrderTableBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => GetTableStatusBloc(),
        ),
        BlocProvider(
          create: (context) => GetCategoriesBloc(CategoryRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(CategoryRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => PosSettingsBloc(PosSettingsRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SummaryBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductSalesBloc(OrderItemRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ItemSalesReportBloc(OrderItemRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DaySalesBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => QrisBloc(MidtransRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => OnlineCheckerBloc(),
        ),
        BlocProvider(
          create: (context) => CreatePrinterBloc(),
        ),
        BlocProvider(
          create: (context) => UpdatePrinterBloc(),
        ),
        BlocProvider(
          create: (context) => GetPrinterReceiptBloc(),
        ),
        BlocProvider(
          create: (context) => GetPrinterCheckerBloc(),
        ),
        BlocProvider(
          create: (context) => GetPrinterKitchenBloc(),
        ),
        BlocProvider(
          create: (context) => GetPrinterBarBloc(),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(OrderRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'POS Resto App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.quicksand(
              color: AppColors.primary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.primary,
            ),
          ),
        ),
        home: FutureBuilder<bool>(
            future: AuthLocalDataSource().isAuthDataExists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  return const DashboardPage();
                } else {
                  return const LoginPage();
                }
              }
              return const Scaffold(
                body: Center(
                  child: Text('Error'),
                ),
              );
            }),
      ),
    );
  }
}
