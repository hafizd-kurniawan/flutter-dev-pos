import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_posresto_app/core/assets/assets.gen.dart';
import 'package:flutter_posresto_app/core/components/buttons.dart';
import 'package:flutter_posresto_app/core/components/custom_text_field.dart';
import 'package:flutter_posresto_app/core/components/spaces.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_posresto_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/pages/dashboard_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final businessNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    businessNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(AuthRemoteDatasource()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
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
                    width: 60,
                    height: 60,
                    color: AppColors.primary,
                  ),
                  const SpaceHeight(16.0),
                  const Text(
                    'Register Tenant',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SpaceHeight(8.0),
                  Text(
                    'Start your 7-day free trial',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SpaceHeight(32.0),

                  // Register Card
                  Container(
                    padding: const EdgeInsets.all(24.0),
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
                        CustomTextField(
                          controller: businessNameController,
                          label: 'Business Name',
                          prefixIcon: const Icon(Icons.store_outlined),
                        ),
                        const SpaceHeight(16.0),
                        CustomTextField(
                          controller: emailController,
                          label: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        const SpaceHeight(16.0),
                        CustomTextField(
                          controller: phoneController,
                          label: 'Phone Number',
                          keyboardType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone_outlined),
                        ),
                        const SpaceHeight(16.0),
                        CustomTextField(
                          controller: addressController,
                          label: 'Address',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                        const SpaceHeight(16.0),
                        CustomTextField(
                          controller: passwordController,
                          label: 'Password',
                          obscureText: !isPasswordVisible,
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

                        BlocConsumer<RegisterBloc, RegisterState>(
                          listener: (context, state) {
                            if (state is RegisterSuccess) {
                              AuthLocalDataSource().saveAuthData(state.authResponseModel);
                              NotificationHelper.showSuccess(context, 'Registration Successful');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const DashboardPage()),
                              );
                            } else if (state is RegisterFailure) {
                              NotificationHelper.showError(context, state.message);
                            }
                          },
                          builder: (context, state) {
                            if (state is RegisterLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return Button.filled(
                              onPressed: () {
                                if (businessNameController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    phoneController.text.isEmpty ||
                                    passwordController.text.isEmpty) {
                                  NotificationHelper.showError(context, 'Please fill all required fields');
                                  return;
                                }
                                context.read<RegisterBloc>().add(
                                      RegisterSubmitted(
                                        businessName: businessNameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        address: addressController.text,
                                        password: passwordController.text,
                                      ),
                                    );
                              },
                              label: 'Register Now',
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SpaceHeight(24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
