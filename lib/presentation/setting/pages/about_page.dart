import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _appVersion = 'Loading...';
  String _buildNumber = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
      });
    } catch (e) {
      setState(() {
        _appVersion = '1.0.0';
        _buildNumber = '1';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About & Help'),
        centerTitle: true,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo/Icon
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.restaurant,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App Name
            Center(
              child: Text(
                'POS Restaurant System',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // App Description
            Center(
              child: Text(
                'Point of Sale for Restaurant',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // App Information Card
            _buildInfoCard(
              title: 'App Information',
              children: [
                _buildInfoRow('Version', _appVersion),
                _buildInfoRow('Build Number', _buildNumber),
                _buildInfoRow('Last Updated', '24 Nov 2025'),
                _buildInfoRow('Platform', 'Flutter'),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Help & Support Card
            _buildInfoCard(
              title: 'Help & Support',
              children: [
                _buildLinkRow(
                  'User Guide',
                  Icons.book,
                  () => _showComingSoon(context, 'User Guide'),
                ),
                _buildLinkRow(
                  'Video Tutorial',
                  Icons.play_circle,
                  () => _showComingSoon(context, 'Video Tutorial'),
                ),
                _buildLinkRow(
                  'FAQ',
                  Icons.help,
                  () => _showComingSoon(context, 'FAQ'),
                ),
                _buildLinkRow(
                  'Contact Support',
                  Icons.support_agent,
                  () => _showContactDialog(context),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Legal Card
            _buildInfoCard(
              title: 'Legal',
              children: [
                _buildLinkRow(
                  'Terms & Conditions',
                  Icons.description,
                  () => _showComingSoon(context, 'Terms & Conditions'),
                ),
                _buildLinkRow(
                  'Privacy Policy',
                  Icons.privacy_tip,
                  () => _showComingSoon(context, 'Privacy Policy'),
                ),
                _buildLinkRow(
                  'Licenses',
                  Icons.assignment,
                  () => _showLicenses(context),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Copyright
            Center(
              child: Text(
                '© 2025 POS Restaurant System\nAll rights reserved',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLinkRow(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Email: support@posrestaurant.com'),
            SizedBox(height: 8),
            Text('Phone: +62 123 4567 890'),
            SizedBox(height: 8),
            Text('WhatsApp: +62 812 3456 7890'),
            SizedBox(height: 16),
            Text(
              'We\'re available Mon-Fri, 9AM-5PM',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'POS Restaurant System',
      applicationVersion: _appVersion,
      applicationIcon: Icon(
        Icons.restaurant,
        size: 48,
        color: AppColors.primary,
      ),
    );
  }
}
