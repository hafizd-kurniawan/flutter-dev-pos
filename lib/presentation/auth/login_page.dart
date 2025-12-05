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
import 'package:flutter_posresto_app/presentation/setting/bloc/settings/settings_bloc.dart';

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
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Background Pattern (Optional - can be added later)
          
          // Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo & Branding
                    SvgPicture.asset(
                      Assets.icons.homeResto.path,
                      width: 80,
                      height: 80,
                      color: AppColors.primary,
                    ),
                    const SpaceHeight(16.0),
                    const Text(
                      'Resto Code With Bahri',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SpaceHeight(8.0),
                    Text(
                      'Sign in to manage your restaurant',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SpaceHeight(32.0),

                    // Login Card
                    Container(
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SpaceHeight(24.0),
                          
                          CustomTextField(
                            controller: emailController,
                            label: 'Email Address',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          const SpaceHeight(16.0),
                          
                          CustomTextField(
                            controller: passwordController,
                            label: 'Password',
                            obscureText: !isPasswordVisible,
                            textInputAction: TextInputAction.done,
                            prefixIcon: const Icon(Icons.lock_outline),
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
                          const SpaceHeight(32.0),
                          
                          BlocListener<LoginBloc, LoginState>(
                            listener: (context, state) {
                              state.maybeWhen(
                                orElse: () {},
                                success: (authResponseModel) async {
                                  _handleLoginSuccess(context, authResponseModel);
                                },
                                error: (message) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                      backgroundColor: AppColors.red,
                                      behavior: SnackBarBehavior.floating,
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
                                      label: 'Sign In',
                                      height: 50,
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
                    ),
                    
                    const SpaceHeight(24.0),
                    Text(
                      '© 2024 Code With Bahri. All rights reserved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLoginSuccess(BuildContext context, dynamic authResponseModel) async {
    print('🔥 LOGIN SUCCESS - Starting product sync...');
    
    // 1. Save auth data
    await AuthLocalDataSource().saveAuthData(authResponseModel);
    print('✅ Auth data saved');

    // Initialize Notification Service
    NotificationService().init();

    // 1.5 Fetch Settings
    if (context.mounted) {
      context.read<SettingsBloc>().add(const SettingsEvent.fetchSettings());
    }
    print('✅ Settings fetch triggered');
    
    // ONLINE ONLY: Skip product sync
    print('🌐 Online Only Mode: Skipping product sync');
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Success'),
          backgroundColor: AppColors.primary,
        ),
      );
      
      // Navigate to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    }
  }
}
