// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get menu => 'Menu';

  @override
  String get orders => 'Orders';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get search_placeholder => 'Search...';

  @override
  String get cart_title => 'Cart';

  @override
  String get total => 'Total';

  @override
  String get checkout => 'Checkout';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get please_wait => 'Please wait';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get payment_success => 'Payment Successful!';

  @override
  String get payment_failed => 'Payment Failed';

  @override
  String get items => 'Items';

  @override
  String get tax => 'Tax';

  @override
  String get service_charge => 'Service Charge';

  @override
  String get discount => 'Discount';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get change => 'Change';

  @override
  String get cash => 'Cash';

  @override
  String get qris => 'QRIS';

  @override
  String get print_receipt => 'Print Receipt';

  @override
  String get new_order => 'New Order';

  @override
  String get sync_data => 'Sync Data';

  @override
  String get notifications => 'Notifications';

  @override
  String get about => 'About & Help';

  @override
  String get language => 'Language';

  @override
  String get select_language => 'Select Language';

  @override
  String get app_info => 'App Info';

  @override
  String get server_sync => 'Server Sync';

  @override
  String get preferences => 'Preferences';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get alerts => 'ALERTS';

  @override
  String low_stock_count(Object count) {
    return '$count products low stock';
  }

  @override
  String pending_orders_count(Object count) {
    return '$count pending orders';
  }

  @override
  String get upgrade_premium_desc => 'Upgrade to Premium to get:';

  @override
  String get view_dashboard => 'View Dashboard';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get retry => 'Retry';

  @override
  String get no_items => 'No Items';

  @override
  String get stock_insufficient => 'Stock Insufficient';

  @override
  String get ok => 'OK';

  @override
  String get no_tax_available => 'No tax available';

  @override
  String get no_discount_available => 'No discount available';

  @override
  String get no_service_available => 'No service available';

  @override
  String get no_table_data => 'No table data';

  @override
  String get welcome_dashboard => 'Welcome to Dashboard';

  @override
  String error_loading_categories_msg(Object message) {
    return 'Error loading categories: $message';
  }

  @override
  String get select_table => 'Select Table';

  @override
  String get search_table => 'Search table...';

  @override
  String get no_table_available => 'No table available';

  @override
  String get select_tax => 'Select Tax';

  @override
  String get no_tax => 'No Tax';

  @override
  String get no_tax_desc => 'Do not use tax';

  @override
  String get tax_applied => 'Tax applied successfully';

  @override
  String get select_discount => 'Select Discount';

  @override
  String get no_discount => 'No Discount';

  @override
  String get no_discount_desc => 'Do not use discount';

  @override
  String get discount_applied => 'Discount applied successfully';

  @override
  String get select_service => 'Select Service';

  @override
  String get no_service => 'No Service';

  @override
  String get no_service_desc => 'Do not use service charge';

  @override
  String service_applied(Object name) {
    return 'Service $name applied';
  }

  @override
  String get save => 'Save';

  @override
  String get all_categories => 'All Categories';

  @override
  String get order_number => 'Order#';

  @override
  String get order_note_label => 'Order Note:';

  @override
  String get order_note_hint => 'Add a note for the kitchen...';

  @override
  String refresh_error(Object count, Object message) {
    return 'Failed to refresh $count items:\n$message';
  }

  @override
  String refresh_failed(Object message) {
    return 'Refresh failed: $message';
  }

  @override
  String get qty => 'Qty';

  @override
  String get price => 'Price';

  @override
  String get proceed_payment => 'Proceed to Payment';

  @override
  String stock_validation_failed(Object message) {
    return 'Stock validation failed: $message';
  }

  @override
  String get select_table_dine_in => 'Select table first for Dine In';

  @override
  String get stock_insufficient_title => 'Stock Insufficient';

  @override
  String get stock_insufficient_message => 'Stock insufficient';

  @override
  String get table_selected => 'Table Selected';

  @override
  String get takeaway_no_table => 'Takeaway (No Table)';

  @override
  String get tap_to_select_table => 'Tap to select table';

  @override
  String get no_table_needed => 'No table needed';

  @override
  String get dine_in => 'Dine In';

  @override
  String get takeaway => 'Takeaway';

  @override
  String get history_orders => 'History Orders';

  @override
  String get filter_date_range => 'Filter Date Range';

  @override
  String get start_date => 'Start Date';

  @override
  String get end_date => 'End Date';

  @override
  String get select_start_date => 'Select Start Date';

  @override
  String get select_end_date => 'Select End Date';

  @override
  String get clear_filter => 'Clear Filter';

  @override
  String get apply_filter => 'Apply Filter';

  @override
  String get filter_active => 'Filter Active';

  @override
  String get filter_by_date => 'Filter by Date';

  @override
  String get update_status => 'Update Status';

  @override
  String get start_cooking_confirm => 'Start Cooking?';

  @override
  String get mark_complete_confirm => 'Mark as Complete?';

  @override
  String get order_note => 'Order Note:';

  @override
  String get printing_receipt => 'Printing receipt...';

  @override
  String get no_printer_found => 'No printer found';

  @override
  String error_printing(Object message) {
    return 'Error printing: $message';
  }

  @override
  String get loading_data => 'Loading data...';

  @override
  String get error_loading_orders => 'Error loading orders';

  @override
  String get dashboard_title => 'Dashboard';

  @override
  String get avg_order => 'Avg Order';

  @override
  String get customers => 'Customers';

  @override
  String get delivery => 'Delivery';

  @override
  String get total_caps => 'TOTAL';

  @override
  String get transaction_report => 'Transaction Report';

  @override
  String get item_sales_report => 'Item Sales Report';

  @override
  String get product_sales_chart => 'Product Sales Chart';

  @override
  String get summary_sales_report => 'Summary Sales Report';

  @override
  String get confirm_payment => 'Confirm Payment';

  @override
  String get enter_customer_name => 'Enter customer name';

  @override
  String get qr_data_empty => 'Error: QR Data is Empty';

  @override
  String get order_note_example => 'Example: No spicy, less ice';

  @override
  String get email_address => 'Email Address';

  @override
  String get sign_in => 'Sign In';

  @override
  String get clear => 'Clear';

  @override
  String get done => 'Done';

  @override
  String get print => 'Print';

  @override
  String get receipt => 'Receipt';

  @override
  String get back => 'Back';

  @override
  String get print_checker => 'Print Checker';

  @override
  String get new_order_received => 'New Order Received! History Updated.';

  @override
  String get order_summary => 'Order Summary';

  @override
  String get item => 'Item';

  @override
  String get payment_details => 'Payment Details';

  @override
  String get customer_name => 'Customer Name';

  @override
  String get payment_method => 'Payment Method';

  @override
  String get cash_amount => 'Cash Amount';

  @override
  String get exact_amount => 'Exact Amount';

  @override
  String get customer_name_required => 'Customer name is required!';

  @override
  String get customer_name_required_takeaway =>
      'Customer name is required for Takeaway!';

  @override
  String get payment_amount_insufficient => 'Payment amount is insufficient!';

  @override
  String get payment_qris => 'QRIS Payment';

  @override
  String get scan_qris => 'Scan QRIS to make payment';

  @override
  String get print_qris => 'Print QRIS';

  @override
  String get item_note => 'Item Note';

  @override
  String get max_chars => 'Max 100 characters';

  @override
  String get add_note => 'Add Note';

  @override
  String get order_type => 'Order Type';

  @override
  String get total_bill => 'Total Bill';

  @override
  String get payment_amount => 'Payment Amount';

  @override
  String get money_insufficient => '⚠️ Money insufficient!';

  @override
  String get payment_time => 'Payment Time';

  @override
  String get generating_pdf => 'Generating PDF...';

  @override
  String get receipt_shared_success => 'Receipt shared successfully!';

  @override
  String error_sharing_receipt(Object error) {
    return 'Error sharing receipt: $error';
  }

  @override
  String get order_saved_success => 'Order Saved Successfully';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get network => 'Network';

  @override
  String get size_58mm => '58 mm';

  @override
  String get size_80mm => '80 mm';

  @override
  String get printer_name => 'Print Name';

  @override
  String get printer_address => 'Address';

  @override
  String get test_print => 'Test Print';

  @override
  String get search_food_placeholder => 'Search for food, coffee, etc..';

  @override
  String get search_tables => 'Search tables...';

  @override
  String get search_generic => 'Search';

  @override
  String get coming_soon => 'Coming Soon';

  @override
  String get customer_name_hint => 'Customer Name';

  @override
  String get total_price_hint => 'Total Price';

  @override
  String get close => 'Close';

  @override
  String get manage_printer => 'Manage Printer';

  @override
  String get no_data_available => 'No data available';

  @override
  String get notification_preview => 'This is how notifications will appear';

  @override
  String get test_notification => 'Test Notification';

  @override
  String get ip_address => 'IP Address';

  @override
  String get paper_size => 'Paper Size';

  @override
  String get printer_type => 'Printer Type';

  @override
  String get sync_products_now => 'Sync Products Now';

  @override
  String get sync_orders_now => 'Sync Orders Now';

  @override
  String get status_available => 'Available';

  @override
  String get tooltip_refresh_data => 'Refresh Data';

  @override
  String get tooltip_print_receipt => 'Print Receipt';

  @override
  String get tooltip_share_receipt => 'Share Receipt';

  @override
  String get tooltip_refresh_orders => 'Refresh Orders';

  @override
  String get notification_sound => 'Notification Sound';

  @override
  String get notification_sound_desc => 'Play sound when notifications arrive';

  @override
  String get new_order_alerts => 'New Order Alerts';

  @override
  String get new_order_alerts_desc => 'Get notified when new orders arrive';

  @override
  String get low_stock_alerts => 'Low Stock Alerts';

  @override
  String get low_stock_alerts_desc =>
      'Get notified when products are running low';

  @override
  String get menu_title => 'Menu';

  @override
  String new_order_body(Object count) {
    return 'You have $count paid orders.';
  }

  @override
  String get app_title => 'POS Resto App';

  @override
  String get error_loading_categories => 'Error loading categories';

  @override
  String get discount_label => 'Discount:';

  @override
  String get tax_label => 'Tax';

  @override
  String get service_label => 'Service';

  @override
  String get push_notifications => 'Push Notifications';

  @override
  String get push_notifications_desc =>
      'Enable or disable all push notifications';

  @override
  String table_name_label(Object name) {
    return 'Table $name';
  }

  @override
  String order_id_label(Object id) {
    return 'Order #$id';
  }

  @override
  String get revenue => 'Revenue';

  @override
  String get sub_total => 'Sub Total';

  @override
  String get address => 'Address';

  @override
  String created_at(Object date) {
    return 'Created At: $date';
  }

  @override
  String data_date(Object date) {
    return 'Data: $date';
  }

  @override
  String get report_title_summary => 'HayoPOS | Summary Sales Report';

  @override
  String get report_title_transaction => 'HayoPOS | Transaction Sales Report';

  @override
  String get time => 'Time';

  @override
  String feature_coming_soon(Object feature) {
    return '$feature will be available in the next update.';
  }

  @override
  String get contact_support => 'Contact Support';

  @override
  String get email_support => 'Email: support@posrestaurant.com';

  @override
  String get phone_support => 'Phone: +62 123 4567 890';

  @override
  String get whatsapp_support => 'WhatsApp: +62 812 3456 7890';

  @override
  String get table_management => 'Table Management';

  @override
  String get table_layout => 'Table Layout';

  @override
  String get add_table => 'Add Table';

  @override
  String get table_name_input => 'Table Name';

  @override
  String get add => 'Add';

  @override
  String get date => 'Date';

  @override
  String get receipt_number => 'Receipt Number';

  @override
  String get customer => 'Customer';

  @override
  String get cashier => 'Cashier';

  @override
  String get table => 'Table';

  @override
  String get self_order => 'Self Order';

  @override
  String get note => 'Note';

  @override
  String subtotal_products(Object count) {
    return 'Subtotal $count Products';
  }

  @override
  String tax_pb1(Object percent) {
    return 'Tax PB1 ($percent%)';
  }

  @override
  String service_charge_receipt(Object percent) {
    return 'Service Charge ($percent%)';
  }

  @override
  String payment_method_receipt(Object method) {
    return 'Payment ($method)';
  }

  @override
  String paid_at(Object date) {
    return 'Paid at: $date';
  }

  @override
  String printed_by(Object name) {
    return 'Printed by: $name';
  }

  @override
  String get thank_you => 'Thank you';

  @override
  String orders_table(Object name) {
    return 'Orders Table $name';
  }

  @override
  String get payment => 'Payment';

  @override
  String get total_payment => 'Total Payment';

  @override
  String get pay => 'Pay';

  @override
  String get sign_in_subtitle => 'Sign in to manage your restaurant';

  @override
  String get welcome_back => 'Welcome Back';

  @override
  String get copyright => '© 2025 HayoPOS. All rights reserved.';

  @override
  String get login_success => 'Login Success';

  @override
  String get process_payment => 'Process Payment';

  @override
  String get sub_total_label => 'Sub Total';

  @override
  String get start_cooking => 'Start Cooking';

  @override
  String get mark_complete => 'Mark Complete';

  @override
  String get walk_in => 'Walk-in';

  @override
  String get items_label => 'Items:';

  @override
  String get language_settings => 'Language';

  @override
  String get sync_data_desc => 'Sync data from and to server';

  @override
  String get notifications_desc => 'Manage notification preferences';

  @override
  String get about_desc => 'App info and support';

  @override
  String get language_desc => 'Change app language';

  @override
  String get kitchen_printer_title => 'Kitchen Printer';

  @override
  String get bar_printer_title => 'Bar Printer';

  @override
  String get receipt_printer_title => 'Receipt Printer';

  @override
  String get checker_printer_title => 'Checker Printer';

  @override
  String get paper_width => 'Width Paper';

  @override
  String get search_printer_title => 'Search Printer';

  @override
  String get bluetooth_enabled_msg =>
      'Bluetooth enabled, please search and connect';

  @override
  String get bluetooth_not_enabled => 'Bluetooth not enabled';

  @override
  String get wait => 'Wait';

  @override
  String get no_bluetooth_linked =>
      'There are no bluetooths linked, go to settings and link the printer';

  @override
  String get touch_to_connect => 'Touch an item in the list to connect';

  @override
  String get connecting => 'Connecting...';

  @override
  String get settings_saved => 'Settings saved successfully';

  @override
  String get printer_disconnected => 'Printer disconnected';

  @override
  String get choose_size => 'Choose Size';

  @override
  String get choose_printer => 'Choose Printer';

  @override
  String get printer_configuration_title => 'Printer Configuration';

  @override
  String get receipt_tab => 'Receipt';

  @override
  String get bill_receipt_desc => 'Bill & Receipt';

  @override
  String get kitchen_tab => 'Kitchen';

  @override
  String get food_orders_desc => 'Food Orders';

  @override
  String get bar_tab => 'Bar';

  @override
  String get drink_orders_desc => 'Drink Orders';

  @override
  String get configuration_title => 'Configuration';

  @override
  String get receipt_printer_desc => 'To Print bill and receipt';

  @override
  String get kitchen_printer_desc => 'To print food to kitchen';

  @override
  String get bar_printer_desc => 'To print drink to bar';

  @override
  String error_message(Object message) {
    return 'Error: $message';
  }

  @override
  String get todays_performance => 'TODAY\'S PERFORMANCE';

  @override
  String get total_sales => 'Total Sales';

  @override
  String get order_types => 'ORDER TYPES';

  @override
  String get top_3_products => 'TOP 3 PRODUCTS';

  @override
  String sold_count(Object count) {
    return '$count sold';
  }

  @override
  String get unlock_full_analytics => 'UNLOCK FULL ANALYTICS';

  @override
  String get feature_profit_analysis => '✅ Profit Analysis';

  @override
  String get feature_customer_insights => '✅ Customer Insights';

  @override
  String get feature_sales_trends => '✅ Sales Trends (7-30 days)';

  @override
  String get feature_export => '✅ Export PDF/Excel';

  @override
  String get feature_advanced_reports => '✅ Advanced Reports';

  @override
  String get free_trial_remaining => 'You have 1 FREE trial view remaining!';

  @override
  String get error_open_web => 'Could not open web dashboard';

  @override
  String get error_open_upgrade => 'Could not open upgrade page';

  @override
  String get summary_sales_report_title => 'Summary Sales Report';

  @override
  String get id_col => 'ID';

  @override
  String get total_col => 'Total';

  @override
  String get sub_total_col => 'Sub Total';

  @override
  String get tax_col => 'Tax';

  @override
  String get discount_col => 'Discount';

  @override
  String get service_col => 'Service';

  @override
  String get total_item_col => 'Total Item';

  @override
  String get cashier_col => 'Cashier';

  @override
  String get time_col => 'Time';

  @override
  String get order_col => 'Order';

  @override
  String get product_col => 'Product';

  @override
  String get qty_col => 'Qty';

  @override
  String get price_col => 'Price';

  @override
  String get total_price_col => 'Total Price';

  @override
  String get app_name => 'HayoPOS';

  @override
  String get no_transactions => 'No transactions at the moment.';

  @override
  String get customer_col => 'Customer';

  @override
  String get status_col => 'Status';

  @override
  String get sync_col => 'Sync';

  @override
  String get payment_status_col => 'Payment Status';

  @override
  String get payment_method_col => 'Payment Method';

  @override
  String get payment_amount_col => 'Payment Amount';

  @override
  String get service_charge_col => 'Service Charge';

  @override
  String get payment_col => 'Payment';

  @override
  String get item_col => 'Item';

  @override
  String get action_col => 'Action';

  @override
  String get pdf_label => 'PDF';

  @override
  String get report_title => 'Report';

  @override
  String revenue_label(Object amount) {
    return 'REVENUE : $amount';
  }

  @override
  String get not_synced => 'Not Synced';

  @override
  String get synced => 'Synced';

  @override
  String get menu_order_title => 'Menu Order';

  @override
  String get table_management_title => 'Table Management';

  @override
  String get history_title => 'History';

  @override
  String get printer_title => 'Printer';

  @override
  String get settings_title => 'Settings';

  @override
  String get pos_resto_title => 'POS Resto';

  @override
  String get logout_success => 'Logout success';

  @override
  String get sync_settings_success => 'Sync settings success';

  @override
  String get sync_settings_failed => 'Sync settings failed';

  @override
  String get syncing_settings => 'Syncing settings...';

  @override
  String get choose_photo => 'Choose Photo';

  @override
  String get item_sales_report_title => 'Item Sales Report';

  @override
  String get company_address_value =>
      'Jalan Melati No. 12, Mranggen, Demak, Central Java, 89568';

  @override
  String get normal_price => 'Normal Price';

  @override
  String get final_total => 'Final Total';

  @override
  String get transaction_id => 'Transaction ID';

  @override
  String get order_by => 'Order By';

  @override
  String get scan_qris_below => 'Scan QRIS Below for Payment';

  @override
  String price_label(Object price) {
    return 'Price : $price';
  }

  @override
  String get date_label => 'Date:';

  @override
  String get receipt_label => 'Receipt:';

  @override
  String get customer_label => 'Customer:';

  @override
  String get cashier_label => 'Cashier:';

  @override
  String table_label(Object name) {
    return 'Table: $name';
  }

  @override
  String get subtotal_label => 'Subtotal:';

  @override
  String tax_label_receipt(Object percent) {
    return 'Tax ($percent%):';
  }

  @override
  String service_label_receipt(Object percent) {
    return 'Service ($percent%):';
  }

  @override
  String get total_label => 'TOTAL:';

  @override
  String payment_label(Object method) {
    return 'Payment ($method):';
  }

  @override
  String get change_label => 'Change:';

  @override
  String get table_checker => 'Table Checker';

  @override
  String get kitchen_title => 'KITCHEN';

  @override
  String get bar_title => 'Table Bar';

  @override
  String get completed_status => 'Completed';

  @override
  String get paid_status => 'Paid';

  @override
  String get cooking_status => 'Cooking';

  @override
  String get added_success => 'Successfully added';

  @override
  String stock_insufficient_cart(Object cart, Object stock) {
    return 'Stock insufficient! Available: $stock, In cart: $cart';
  }

  @override
  String get stock_verification_failed =>
      'Cannot verify online stock. Added based on local stock.';
}
