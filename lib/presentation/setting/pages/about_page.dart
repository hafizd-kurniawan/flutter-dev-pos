import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0), // Padding handled by parent
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // Limit width for better readability on desktop
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo/Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // App Name
              Center(
                child: Text(
                  'POS Restaurant System',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
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
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
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
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.quicksand(
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
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLinkRow(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
  
  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Coming Soon', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
        content: Text('$feature will be available in the next update.', style: GoogleFonts.quicksand()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
  
  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: support@posrestaurant.com', style: GoogleFonts.quicksand()),
            const SizedBox(height: 8),
            Text('Phone: +62 123 4567 890', style: GoogleFonts.quicksand()),
            const SizedBox(height: 8),
            Text('WhatsApp: +62 812 3456 7890', style: GoogleFonts.quicksand()),
            const SizedBox(height: 16),
            Text(
              'We\'re available Mon-Fri, 9AM-5PM',
              style: GoogleFonts.quicksand(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
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
