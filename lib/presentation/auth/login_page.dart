import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_storage_helper.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../core/assets/assets.gen.dart';
import '../../core/components/buttons.dart';
import '../../core/components/custom_text_field.dart';
import '../../core/components/spaces.dart';
import '../../core/constants/colors.dart';
import '../home/pages/dashboard_page.dart';
import 'bloc/login/login_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/settings/settings_bloc.dart'; // NEW

import 'package:flutter_posresto_app/core/services/notification_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 260.0, vertical: 20.0),
        children: [
          const SpaceHeight(80.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 130.0),
              child: SvgPicture.asset(
                Assets.icons.homeResto.path,
                width: 100,
                height: 100,
                color: AppColors.primary,
              )),
          const SpaceHeight(24.0),
          const Center(
            child: Text(
              'Resto Code With Bahri',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SpaceHeight(8.0),
          const Center(
            child: Text(
              'Akses Login Kasir Resto',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          const SpaceHeight(40.0),
          CustomTextField(
            controller: emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SpaceHeight(12.0),
          CustomTextField(
            controller: passwordController,
            label: 'Password',
            obscureText: !isPasswordVisible,
            textInputAction: TextInputAction.done,
            suffixIcon: InkWell(
              onTap: () => setState(() {
                isPasswordVisible = !isPasswordVisible;
              }),
              child: Icon(
                isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
          const SpaceHeight(24.0),
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                success: (authResponseModel) async {
                  print('🔥 LOGIN SUCCESS - Starting product sync...');
                  
                  // 1. Save auth data
                  await AuthLocalDataSource().saveAuthData(authResponseModel);
                  print('✅ Auth data saved');

                  // Initialize Notification Service (NEW)
                  NotificationService().init();

                  // 1.5 Fetch Settings (NEW)
                  context.read<SettingsBloc>().add(const SettingsEvent.fetchSettings());
                  print('✅ Settings fetch triggered');
                  
                  // 2. Show loading dialog for product sync
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Loading data produk...'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    print('✅ Dialog shown');
                  }
                  
                  try {
                    // 3. Sync products from server
                    print('🌐 Fetching products from API...');
                    final productResult = await ProductRemoteDatasource().getProducts();
                    print('📦 Product result received');
                    
                    await productResult.fold(
                      (error) async {
                        print('❌ ERROR: $error');
                        // Failed to sync products
                        if (context.mounted) {
                          Navigator.pop(context); // Close loading dialog
                          print('✅ Dialog closed (error)');
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal load produk: $error'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          
                          // Navigate anyway (graceful degradation)
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardPage(),
                            ),
                          );
                          print('✅ Navigated to dashboard (error flow)');
                        }
                      },
                      (productResponse) async {
                        print('✅ SUCCESS: Got ${productResponse.data?.length ?? 0} products');
                        
                        // Save products to storage (platform-specific)
                        if (!kIsWeb) {
                          // Mobile/Desktop: Save to SQLite
                          print('💾 Deleting old products...');
                          await ProductLocalDatasource.instance.deleteAllProducts();
                          
                          print('💾 Inserting new products...');
                          await ProductLocalDatasource.instance
                              .insertProducts(productResponse.data ?? []);
                          print('✅ Products saved to SQLite');
                        } else {
                          // Web: Save to SharedPreferences
                          print('🌐 Web platform detected - using SharedPreferences');
                          await ProductStorageHelper.saveProducts(productResponse.data ?? []);
                          print('✅ Products saved to SharedPreferences');
                        }
                        
                        if (context.mounted) {
                          Navigator.pop(context); // Close loading dialog
                          print('✅ Dialog closed (success)');
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '✅ ${productResponse.data?.length ?? 0} produk berhasil dimuat!',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          print('✅ Toast shown');
                          
                          // Navigate to dashboard
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardPage(),
                            ),
                          );
                          print('✅ Navigated to dashboard (success flow)');
                        }
                      },
                    );
                  } catch (e) {
                    print('💥 EXCEPTION: $e');
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardPage(),
                        ),
                      );
                    }
                  }
                },
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.red,
                    ),
                  );
                },
              );
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return Button.filled(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                              LoginEvent.login(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      },
                      label: 'Masuk',
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
