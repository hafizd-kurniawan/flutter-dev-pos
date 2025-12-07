import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';

import '../../../core/constants/colors.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../auth/bloc/logout/logout_bloc.dart';
import '../../auth/login_page.dart';



class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to Dashboard'),
            
            const SizedBox(
              height: 100,
            ),
            BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                state.maybeMap(
                  orElse: () {},
                  error: (e) {
                    NotificationHelper.showError(context, e.message);
                  },
                  success: (value) {
                    AuthLocalDataSource().removeAuthData();
                    NotificationHelper.showSuccess(context, 'Logout success');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }));
                  },
                );
              },
              child: ElevatedButton(
                onPressed: () {
                  context.read<LogoutBloc>().add(const LogoutEvent.logout());
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}