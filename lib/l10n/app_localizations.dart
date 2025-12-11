import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @search_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search_placeholder;

  /// No description provided for @cart_title.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart_title;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get please_wait;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @payment_success.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get payment_success;

  /// No description provided for @payment_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get payment_failed;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @service_charge.
  ///
  /// In en, this message translates to:
  /// **'Service Charge'**
  String get service_charge;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @qris.
  ///
  /// In en, this message translates to:
  /// **'QRIS'**
  String get qris;

  /// No description provided for @print_receipt.
  ///
  /// In en, this message translates to:
  /// **'Print Receipt'**
  String get print_receipt;

  /// No description provided for @new_order.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get new_order;

  /// No description provided for @sync_data.
  ///
  /// In en, this message translates to:
  /// **'Sync Data'**
  String get sync_data;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About & Help'**
  String get about;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @app_info.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get app_info;

  /// No description provided for @server_sync.
  ///
  /// In en, this message translates to:
  /// **'Server Sync'**
  String get server_sync;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'ALERTS'**
  String get alerts;

  /// No description provided for @low_stock_count.
  ///
  /// In en, this message translates to:
  /// **'{count} products low stock'**
  String low_stock_count(Object count);

  /// No description provided for @pending_orders_count.
  ///
  /// In en, this message translates to:
  /// **'{count} pending orders'**
  String pending_orders_count(Object count);

  /// No description provided for @upgrade_premium_desc.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to get:'**
  String get upgrade_premium_desc;

  /// No description provided for @view_dashboard.
  ///
  /// In en, this message translates to:
  /// **'View Dashboard'**
  String get view_dashboard;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @no_items.
  ///
  /// In en, this message translates to:
  /// **'No Items'**
  String get no_items;

  /// No description provided for @stock_insufficient.
  ///
  /// In en, this message translates to:
  /// **'Stock Insufficient'**
  String get stock_insufficient;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @no_tax_available.
  ///
  /// In en, this message translates to:
  /// **'No tax available'**
  String get no_tax_available;

  /// No description provided for @no_discount_available.
  ///
  /// In en, this message translates to:
  /// **'No discount available'**
  String get no_discount_available;

  /// No description provided for @no_service_available.
  ///
  /// In en, this message translates to:
  /// **'No service available'**
  String get no_service_available;

  /// No description provided for @no_table_data.
  ///
  /// In en, this message translates to:
  /// **'No table data'**
  String get no_table_data;

  /// No description provided for @welcome_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Dashboard'**
  String get welcome_dashboard;

  /// No description provided for @error_loading_categories_msg.
  ///
  /// In en, this message translates to:
  /// **'Error loading categories: {message}'**
  String error_loading_categories_msg(Object message);

  /// No description provided for @select_table.
  ///
  /// In en, this message translates to:
  /// **'Select Table'**
  String get select_table;

  /// No description provided for @search_table.
  ///
  /// In en, this message translates to:
  /// **'Search table...'**
  String get search_table;

  /// No description provided for @no_table_available.
  ///
  /// In en, this message translates to:
  /// **'No table available'**
  String get no_table_available;

  /// No description provided for @select_tax.
  ///
  /// In en, this message translates to:
  /// **'Select Tax'**
  String get select_tax;

  /// No description provided for @no_tax.
  ///
  /// In en, this message translates to:
  /// **'No Tax'**
  String get no_tax;

  /// No description provided for @no_tax_desc.
  ///
  /// In en, this message translates to:
  /// **'Do not use tax'**
  String get no_tax_desc;

  /// No description provided for @tax_applied.
  ///
  /// In en, this message translates to:
  /// **'Tax applied successfully'**
  String get tax_applied;

  /// No description provided for @select_discount.
  ///
  /// In en, this message translates to:
  /// **'Select Discount'**
  String get select_discount;

  /// No description provided for @no_discount.
  ///
  /// In en, this message translates to:
  /// **'No Discount'**
  String get no_discount;

  /// No description provided for @no_discount_desc.
  ///
  /// In en, this message translates to:
  /// **'Do not use discount'**
  String get no_discount_desc;

  /// No description provided for @discount_applied.
  ///
  /// In en, this message translates to:
  /// **'Discount applied successfully'**
  String get discount_applied;

  /// No description provided for @select_service.
  ///
  /// In en, this message translates to:
  /// **'Select Service'**
  String get select_service;

  /// No description provided for @no_service.
  ///
  /// In en, this message translates to:
  /// **'No Service'**
  String get no_service;

  /// No description provided for @no_service_desc.
  ///
  /// In en, this message translates to:
  /// **'Do not use service charge'**
  String get no_service_desc;

  /// No description provided for @service_applied.
  ///
  /// In en, this message translates to:
  /// **'Service {name} applied'**
  String service_applied(Object name);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @all_categories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get all_categories;

  /// No description provided for @order_number.
  ///
  /// In en, this message translates to:
  /// **'Order#'**
  String get order_number;

  /// No description provided for @order_note_label.
  ///
  /// In en, this message translates to:
  /// **'Order Note:'**
  String get order_note_label;

  /// No description provided for @order_note_hint.
  ///
  /// In en, this message translates to:
  /// **'Add a note for the kitchen...'**
  String get order_note_hint;

  /// No description provided for @refresh_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to refresh {count} items:\n{message}'**
  String refresh_error(Object count, Object message);

  /// No description provided for @refresh_failed.
  ///
  /// In en, this message translates to:
  /// **'Refresh failed: {message}'**
  String refresh_failed(Object message);

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @proceed_payment.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get proceed_payment;

  /// No description provided for @stock_validation_failed.
  ///
  /// In en, this message translates to:
  /// **'Stock validation failed: {message}'**
  String stock_validation_failed(Object message);

  /// No description provided for @select_table_dine_in.
  ///
  /// In en, this message translates to:
  /// **'Select table first for Dine In'**
  String get select_table_dine_in;

  /// No description provided for @stock_insufficient_title.
  ///
  /// In en, this message translates to:
  /// **'Stock Insufficient'**
  String get stock_insufficient_title;

  /// No description provided for @stock_insufficient_message.
  ///
  /// In en, this message translates to:
  /// **'Stock insufficient'**
  String get stock_insufficient_message;

  /// No description provided for @table_selected.
  ///
  /// In en, this message translates to:
  /// **'Table Selected'**
  String get table_selected;

  /// No description provided for @takeaway_no_table.
  ///
  /// In en, this message translates to:
  /// **'Takeaway (No Table)'**
  String get takeaway_no_table;

  /// No description provided for @tap_to_select_table.
  ///
  /// In en, this message translates to:
  /// **'Tap to select table'**
  String get tap_to_select_table;

  /// No description provided for @no_table_needed.
  ///
  /// In en, this message translates to:
  /// **'No table needed'**
  String get no_table_needed;

  /// No description provided for @dine_in.
  ///
  /// In en, this message translates to:
  /// **'Dine In'**
  String get dine_in;

  /// No description provided for @takeaway.
  ///
  /// In en, this message translates to:
  /// **'Takeaway'**
  String get takeaway;

  /// No description provided for @history_orders.
  ///
  /// In en, this message translates to:
  /// **'History Orders'**
  String get history_orders;

  /// No description provided for @filter_date_range.
  ///
  /// In en, this message translates to:
  /// **'Filter Date Range'**
  String get filter_date_range;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get start_date;

  /// No description provided for @end_date.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get end_date;

  /// No description provided for @select_start_date.
  ///
  /// In en, this message translates to:
  /// **'Select Start Date'**
  String get select_start_date;

  /// No description provided for @select_end_date.
  ///
  /// In en, this message translates to:
  /// **'Select End Date'**
  String get select_end_date;

  /// No description provided for @clear_filter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clear_filter;

  /// No description provided for @apply_filter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get apply_filter;

  /// No description provided for @filter_active.
  ///
  /// In en, this message translates to:
  /// **'Filter Active'**
  String get filter_active;

  /// No description provided for @filter_by_date.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filter_by_date;

  /// No description provided for @update_status.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get update_status;

  /// No description provided for @start_cooking_confirm.
  ///
  /// In en, this message translates to:
  /// **'Start Cooking?'**
  String get start_cooking_confirm;

  /// No description provided for @mark_complete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete?'**
  String get mark_complete_confirm;

  /// No description provided for @order_note.
  ///
  /// In en, this message translates to:
  /// **'Order Note:'**
  String get order_note;

  /// No description provided for @printing_receipt.
  ///
  /// In en, this message translates to:
  /// **'Printing receipt...'**
  String get printing_receipt;

  /// No description provided for @no_printer_found.
  ///
  /// In en, this message translates to:
  /// **'No printer found'**
  String get no_printer_found;

  /// No description provided for @error_printing.
  ///
  /// In en, this message translates to:
  /// **'Error printing: {message}'**
  String error_printing(Object message);

  /// No description provided for @loading_data.
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loading_data;

  /// No description provided for @error_loading_orders.
  ///
  /// In en, this message translates to:
  /// **'Error loading orders'**
  String get error_loading_orders;

  /// No description provided for @dashboard_title.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard_title;

  /// No description provided for @avg_order.
  ///
  /// In en, this message translates to:
  /// **'Avg Order'**
  String get avg_order;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @total_caps.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get total_caps;

  /// No description provided for @transaction_report.
  ///
  /// In en, this message translates to:
  /// **'Transaction Report'**
  String get transaction_report;

  /// No description provided for @item_sales_report.
  ///
  /// In en, this message translates to:
  /// **'Item Sales Report'**
  String get item_sales_report;

  /// No description provided for @product_sales_chart.
  ///
  /// In en, this message translates to:
  /// **'Product Sales Chart'**
  String get product_sales_chart;

  /// No description provided for @summary_sales_report.
  ///
  /// In en, this message translates to:
  /// **'Summary Sales Report'**
  String get summary_sales_report;

  /// No description provided for @confirm_payment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirm_payment;

  /// No description provided for @enter_customer_name.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get enter_customer_name;

  /// No description provided for @qr_data_empty.
  ///
  /// In en, this message translates to:
  /// **'Error: QR Data is Empty'**
  String get qr_data_empty;

  /// No description provided for @order_note_example.
  ///
  /// In en, this message translates to:
  /// **'Example: No spicy, less ice'**
  String get order_note_example;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @print_checker.
  ///
  /// In en, this message translates to:
  /// **'Print Checker'**
  String get print_checker;

  /// No description provided for @new_order_received.
  ///
  /// In en, this message translates to:
  /// **'New Order Received! History Updated.'**
  String get new_order_received;

  /// No description provided for @order_summary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get order_summary;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @payment_details.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get payment_details;

  /// No description provided for @customer_name.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customer_name;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @cash_amount.
  ///
  /// In en, this message translates to:
  /// **'Cash Amount'**
  String get cash_amount;

  /// No description provided for @exact_amount.
  ///
  /// In en, this message translates to:
  /// **'Exact Amount'**
  String get exact_amount;

  /// No description provided for @customer_name_required.
  ///
  /// In en, this message translates to:
  /// **'Customer name is required!'**
  String get customer_name_required;

  /// No description provided for @customer_name_required_takeaway.
  ///
  /// In en, this message translates to:
  /// **'Customer name is required for Takeaway!'**
  String get customer_name_required_takeaway;

  /// No description provided for @payment_amount_insufficient.
  ///
  /// In en, this message translates to:
  /// **'Payment amount is insufficient!'**
  String get payment_amount_insufficient;

  /// No description provided for @payment_qris.
  ///
  /// In en, this message translates to:
  /// **'QRIS Payment'**
  String get payment_qris;

  /// No description provided for @scan_qris.
  ///
  /// In en, this message translates to:
  /// **'Scan QRIS to make payment'**
  String get scan_qris;

  /// No description provided for @print_qris.
  ///
  /// In en, this message translates to:
  /// **'Print QRIS'**
  String get print_qris;

  /// No description provided for @item_note.
  ///
  /// In en, this message translates to:
  /// **'Item Note'**
  String get item_note;

  /// No description provided for @max_chars.
  ///
  /// In en, this message translates to:
  /// **'Max 100 characters'**
  String get max_chars;

  /// No description provided for @add_note.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get add_note;

  /// No description provided for @order_type.
  ///
  /// In en, this message translates to:
  /// **'Order Type'**
  String get order_type;

  /// No description provided for @total_bill.
  ///
  /// In en, this message translates to:
  /// **'Total Bill'**
  String get total_bill;

  /// No description provided for @payment_amount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get payment_amount;

  /// No description provided for @money_insufficient.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Money insufficient!'**
  String get money_insufficient;

  /// No description provided for @payment_time.
  ///
  /// In en, this message translates to:
  /// **'Payment Time'**
  String get payment_time;

  /// No description provided for @generating_pdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generating_pdf;

  /// No description provided for @receipt_shared_success.
  ///
  /// In en, this message translates to:
  /// **'Receipt shared successfully!'**
  String get receipt_shared_success;

  /// No description provided for @error_sharing_receipt.
  ///
  /// In en, this message translates to:
  /// **'Error sharing receipt: {error}'**
  String error_sharing_receipt(Object error);

  /// No description provided for @order_saved_success.
  ///
  /// In en, this message translates to:
  /// **'Order Saved Successfully'**
  String get order_saved_success;

  /// No description provided for @bluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @size_58mm.
  ///
  /// In en, this message translates to:
  /// **'58 mm'**
  String get size_58mm;

  /// No description provided for @size_80mm.
  ///
  /// In en, this message translates to:
  /// **'80 mm'**
  String get size_80mm;

  /// No description provided for @printer_name.
  ///
  /// In en, this message translates to:
  /// **'Print Name'**
  String get printer_name;

  /// No description provided for @printer_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get printer_address;

  /// No description provided for @test_print.
  ///
  /// In en, this message translates to:
  /// **'Test Print'**
  String get test_print;

  /// No description provided for @search_food_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search for food, coffee, etc..'**
  String get search_food_placeholder;

  /// No description provided for @search_tables.
  ///
  /// In en, this message translates to:
  /// **'Search tables...'**
  String get search_tables;

  /// No description provided for @search_generic.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search_generic;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get coming_soon;

  /// No description provided for @customer_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customer_name_hint;

  /// No description provided for @total_price_hint.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get total_price_hint;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @manage_printer.
  ///
  /// In en, this message translates to:
  /// **'Manage Printer'**
  String get manage_printer;

  /// No description provided for @no_data_available.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get no_data_available;

  /// No description provided for @notification_preview.
  ///
  /// In en, this message translates to:
  /// **'This is how notifications will appear'**
  String get notification_preview;

  /// No description provided for @test_notification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get test_notification;

  /// No description provided for @ip_address.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ip_address;

  /// No description provided for @paper_size.
  ///
  /// In en, this message translates to:
  /// **'Paper Size'**
  String get paper_size;

  /// No description provided for @printer_type.
  ///
  /// In en, this message translates to:
  /// **'Printer Type'**
  String get printer_type;

  /// No description provided for @sync_products_now.
  ///
  /// In en, this message translates to:
  /// **'Sync Products Now'**
  String get sync_products_now;

  /// No description provided for @sync_orders_now.
  ///
  /// In en, this message translates to:
  /// **'Sync Orders Now'**
  String get sync_orders_now;

  /// No description provided for @status_available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get status_available;

  /// No description provided for @tooltip_refresh_data.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get tooltip_refresh_data;

  /// No description provided for @tooltip_print_receipt.
  ///
  /// In en, this message translates to:
  /// **'Print Receipt'**
  String get tooltip_print_receipt;

  /// No description provided for @tooltip_share_receipt.
  ///
  /// In en, this message translates to:
  /// **'Share Receipt'**
  String get tooltip_share_receipt;

  /// No description provided for @tooltip_refresh_orders.
  ///
  /// In en, this message translates to:
  /// **'Refresh Orders'**
  String get tooltip_refresh_orders;

  /// No description provided for @notification_sound.
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notification_sound;

  /// No description provided for @notification_sound_desc.
  ///
  /// In en, this message translates to:
  /// **'Play sound when notifications arrive'**
  String get notification_sound_desc;

  /// No description provided for @new_order_alerts.
  ///
  /// In en, this message translates to:
  /// **'New Order Alerts'**
  String get new_order_alerts;

  /// No description provided for @new_order_alerts_desc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when new orders arrive'**
  String get new_order_alerts_desc;

  /// No description provided for @low_stock_alerts.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get low_stock_alerts;

  /// No description provided for @low_stock_alerts_desc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when products are running low'**
  String get low_stock_alerts_desc;

  /// No description provided for @menu_title.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu_title;

  /// No description provided for @new_order_body.
  ///
  /// In en, this message translates to:
  /// **'You have {count} paid orders.'**
  String new_order_body(Object count);

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'POS Resto App'**
  String get app_title;

  /// No description provided for @error_loading_categories.
  ///
  /// In en, this message translates to:
  /// **'Error loading categories'**
  String get error_loading_categories;

  /// No description provided for @discount_label.
  ///
  /// In en, this message translates to:
  /// **'Discount:'**
  String get discount_label;

  /// No description provided for @tax_label.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax_label;

  /// No description provided for @service_label.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service_label;

  /// No description provided for @push_notifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get push_notifications;

  /// No description provided for @push_notifications_desc.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable all push notifications'**
  String get push_notifications_desc;

  /// No description provided for @table_name_label.
  ///
  /// In en, this message translates to:
  /// **'Table {name}'**
  String table_name_label(Object name);

  /// No description provided for @order_id_label.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String order_id_label(Object id);

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @sub_total.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get sub_total;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @created_at.
  ///
  /// In en, this message translates to:
  /// **'Created At: {date}'**
  String created_at(Object date);

  /// No description provided for @data_date.
  ///
  /// In en, this message translates to:
  /// **'Data: {date}'**
  String data_date(Object date);

  /// No description provided for @report_title_summary.
  ///
  /// In en, this message translates to:
  /// **'HayoPOS | Summary Sales Report'**
  String get report_title_summary;

  /// No description provided for @report_title_transaction.
  ///
  /// In en, this message translates to:
  /// **'HayoPOS | Transaction Sales Report'**
  String get report_title_transaction;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @feature_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'{feature} will be available in the next update.'**
  String feature_coming_soon(Object feature);

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support;

  /// No description provided for @email_support.
  ///
  /// In en, this message translates to:
  /// **'Email: support@posrestaurant.com'**
  String get email_support;

  /// No description provided for @phone_support.
  ///
  /// In en, this message translates to:
  /// **'Phone: +62 123 4567 890'**
  String get phone_support;

  /// No description provided for @whatsapp_support.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp: +62 812 3456 7890'**
  String get whatsapp_support;

  /// No description provided for @table_management.
  ///
  /// In en, this message translates to:
  /// **'Table Management'**
  String get table_management;

  /// No description provided for @table_layout.
  ///
  /// In en, this message translates to:
  /// **'Table Layout'**
  String get table_layout;

  /// No description provided for @add_table.
  ///
  /// In en, this message translates to:
  /// **'Add Table'**
  String get add_table;

  /// No description provided for @table_name_input.
  ///
  /// In en, this message translates to:
  /// **'Table Name'**
  String get table_name_input;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @receipt_number.
  ///
  /// In en, this message translates to:
  /// **'Receipt Number'**
  String get receipt_number;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @cashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get cashier;

  /// No description provided for @table.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get table;

  /// No description provided for @self_order.
  ///
  /// In en, this message translates to:
  /// **'Self Order'**
  String get self_order;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @subtotal_products.
  ///
  /// In en, this message translates to:
  /// **'Subtotal {count} Products'**
  String subtotal_products(Object count);

  /// No description provided for @tax_pb1.
  ///
  /// In en, this message translates to:
  /// **'Tax PB1 ({percent}%)'**
  String tax_pb1(Object percent);

  /// No description provided for @service_charge_receipt.
  ///
  /// In en, this message translates to:
  /// **'Service Charge ({percent}%)'**
  String service_charge_receipt(Object percent);

  /// No description provided for @payment_method_receipt.
  ///
  /// In en, this message translates to:
  /// **'Payment ({method})'**
  String payment_method_receipt(Object method);

  /// No description provided for @paid_at.
  ///
  /// In en, this message translates to:
  /// **'Paid at: {date}'**
  String paid_at(Object date);

  /// No description provided for @printed_by.
  ///
  /// In en, this message translates to:
  /// **'Printed by: {name}'**
  String printed_by(Object name);

  /// No description provided for @thank_you.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thank_you;

  /// No description provided for @orders_table.
  ///
  /// In en, this message translates to:
  /// **'Orders Table {name}'**
  String orders_table(Object name);

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @total_payment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get total_payment;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @sign_in_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your restaurant'**
  String get sign_in_subtitle;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome_back;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 HayoPOS. All rights reserved.'**
  String get copyright;

  /// No description provided for @login_success.
  ///
  /// In en, this message translates to:
  /// **'Login Success'**
  String get login_success;

  /// No description provided for @process_payment.
  ///
  /// In en, this message translates to:
  /// **'Process Payment'**
  String get process_payment;

  /// No description provided for @sub_total_label.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get sub_total_label;

  /// No description provided for @start_cooking.
  ///
  /// In en, this message translates to:
  /// **'Start Cooking'**
  String get start_cooking;

  /// No description provided for @mark_complete.
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get mark_complete;

  /// No description provided for @walk_in.
  ///
  /// In en, this message translates to:
  /// **'Walk-in'**
  String get walk_in;

  /// No description provided for @items_label.
  ///
  /// In en, this message translates to:
  /// **'Items:'**
  String get items_label;

  /// No description provided for @language_settings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_settings;

  /// No description provided for @sync_data_desc.
  ///
  /// In en, this message translates to:
  /// **'Sync data from and to server'**
  String get sync_data_desc;

  /// No description provided for @notifications_desc.
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences'**
  String get notifications_desc;

  /// No description provided for @about_desc.
  ///
  /// In en, this message translates to:
  /// **'App info and support'**
  String get about_desc;

  /// No description provided for @language_desc.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get language_desc;

  /// No description provided for @kitchen_printer_title.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Printer'**
  String get kitchen_printer_title;

  /// No description provided for @bar_printer_title.
  ///
  /// In en, this message translates to:
  /// **'Bar Printer'**
  String get bar_printer_title;

  /// No description provided for @receipt_printer_title.
  ///
  /// In en, this message translates to:
  /// **'Receipt Printer'**
  String get receipt_printer_title;

  /// No description provided for @checker_printer_title.
  ///
  /// In en, this message translates to:
  /// **'Checker Printer'**
  String get checker_printer_title;

  /// No description provided for @paper_width.
  ///
  /// In en, this message translates to:
  /// **'Width Paper'**
  String get paper_width;

  /// No description provided for @search_printer_title.
  ///
  /// In en, this message translates to:
  /// **'Search Printer'**
  String get search_printer_title;

  /// No description provided for @bluetooth_enabled_msg.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth enabled, please search and connect'**
  String get bluetooth_enabled_msg;

  /// No description provided for @bluetooth_not_enabled.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth not enabled'**
  String get bluetooth_not_enabled;

  /// No description provided for @wait.
  ///
  /// In en, this message translates to:
  /// **'Wait'**
  String get wait;

  /// No description provided for @no_bluetooth_linked.
  ///
  /// In en, this message translates to:
  /// **'There are no bluetooths linked, go to settings and link the printer'**
  String get no_bluetooth_linked;

  /// No description provided for @touch_to_connect.
  ///
  /// In en, this message translates to:
  /// **'Touch an item in the list to connect'**
  String get touch_to_connect;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @settings_saved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settings_saved;

  /// No description provided for @printer_disconnected.
  ///
  /// In en, this message translates to:
  /// **'Printer disconnected'**
  String get printer_disconnected;

  /// No description provided for @choose_size.
  ///
  /// In en, this message translates to:
  /// **'Choose Size'**
  String get choose_size;

  /// No description provided for @choose_printer.
  ///
  /// In en, this message translates to:
  /// **'Choose Printer'**
  String get choose_printer;

  /// No description provided for @printer_configuration_title.
  ///
  /// In en, this message translates to:
  /// **'Printer Configuration'**
  String get printer_configuration_title;

  /// No description provided for @receipt_tab.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt_tab;

  /// No description provided for @bill_receipt_desc.
  ///
  /// In en, this message translates to:
  /// **'Bill & Receipt'**
  String get bill_receipt_desc;

  /// No description provided for @kitchen_tab.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kitchen_tab;

  /// No description provided for @food_orders_desc.
  ///
  /// In en, this message translates to:
  /// **'Food Orders'**
  String get food_orders_desc;

  /// No description provided for @bar_tab.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get bar_tab;

  /// No description provided for @drink_orders_desc.
  ///
  /// In en, this message translates to:
  /// **'Drink Orders'**
  String get drink_orders_desc;

  /// No description provided for @configuration_title.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration_title;

  /// No description provided for @receipt_printer_desc.
  ///
  /// In en, this message translates to:
  /// **'To Print bill and receipt'**
  String get receipt_printer_desc;

  /// No description provided for @kitchen_printer_desc.
  ///
  /// In en, this message translates to:
  /// **'To print food to kitchen'**
  String get kitchen_printer_desc;

  /// No description provided for @bar_printer_desc.
  ///
  /// In en, this message translates to:
  /// **'To print drink to bar'**
  String get bar_printer_desc;

  /// No description provided for @error_message.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error_message(Object message);

  /// No description provided for @todays_performance.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S PERFORMANCE'**
  String get todays_performance;

  /// No description provided for @total_sales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get total_sales;

  /// No description provided for @order_types.
  ///
  /// In en, this message translates to:
  /// **'ORDER TYPES'**
  String get order_types;

  /// No description provided for @top_3_products.
  ///
  /// In en, this message translates to:
  /// **'TOP 3 PRODUCTS'**
  String get top_3_products;

  /// No description provided for @sold_count.
  ///
  /// In en, this message translates to:
  /// **'{count} sold'**
  String sold_count(Object count);

  /// No description provided for @unlock_full_analytics.
  ///
  /// In en, this message translates to:
  /// **'UNLOCK FULL ANALYTICS'**
  String get unlock_full_analytics;

  /// No description provided for @feature_profit_analysis.
  ///
  /// In en, this message translates to:
  /// **'✅ Profit Analysis'**
  String get feature_profit_analysis;

  /// No description provided for @feature_customer_insights.
  ///
  /// In en, this message translates to:
  /// **'✅ Customer Insights'**
  String get feature_customer_insights;

  /// No description provided for @feature_sales_trends.
  ///
  /// In en, this message translates to:
  /// **'✅ Sales Trends (7-30 days)'**
  String get feature_sales_trends;

  /// No description provided for @feature_export.
  ///
  /// In en, this message translates to:
  /// **'✅ Export PDF/Excel'**
  String get feature_export;

  /// No description provided for @feature_advanced_reports.
  ///
  /// In en, this message translates to:
  /// **'✅ Advanced Reports'**
  String get feature_advanced_reports;

  /// No description provided for @free_trial_remaining.
  ///
  /// In en, this message translates to:
  /// **'You have 1 FREE trial view remaining!'**
  String get free_trial_remaining;

  /// No description provided for @error_open_web.
  ///
  /// In en, this message translates to:
  /// **'Could not open web dashboard'**
  String get error_open_web;

  /// No description provided for @error_open_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Could not open upgrade page'**
  String get error_open_upgrade;

  /// No description provided for @summary_sales_report_title.
  ///
  /// In en, this message translates to:
  /// **'Summary Sales Report'**
  String get summary_sales_report_title;

  /// No description provided for @id_col.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id_col;

  /// No description provided for @total_col.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total_col;

  /// No description provided for @sub_total_col.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get sub_total_col;

  /// No description provided for @tax_col.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax_col;

  /// No description provided for @discount_col.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount_col;

  /// No description provided for @service_col.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service_col;

  /// No description provided for @total_item_col.
  ///
  /// In en, this message translates to:
  /// **'Total Item'**
  String get total_item_col;

  /// No description provided for @cashier_col.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get cashier_col;

  /// No description provided for @time_col.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time_col;

  /// No description provided for @order_col.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order_col;

  /// No description provided for @product_col.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product_col;

  /// No description provided for @qty_col.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty_col;

  /// No description provided for @price_col.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price_col;

  /// No description provided for @total_price_col.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get total_price_col;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'HayoPOS'**
  String get app_name;

  /// No description provided for @no_transactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions at the moment.'**
  String get no_transactions;

  /// No description provided for @customer_col.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer_col;

  /// No description provided for @status_col.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status_col;

  /// No description provided for @sync_col.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync_col;

  /// No description provided for @payment_status_col.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get payment_status_col;

  /// No description provided for @payment_method_col.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method_col;

  /// No description provided for @payment_amount_col.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get payment_amount_col;

  /// No description provided for @service_charge_col.
  ///
  /// In en, this message translates to:
  /// **'Service Charge'**
  String get service_charge_col;

  /// No description provided for @payment_col.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment_col;

  /// No description provided for @item_col.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item_col;

  /// No description provided for @action_col.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action_col;

  /// No description provided for @pdf_label.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf_label;

  /// No description provided for @report_title.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report_title;

  /// No description provided for @revenue_label.
  ///
  /// In en, this message translates to:
  /// **'REVENUE : {amount}'**
  String revenue_label(Object amount);

  /// No description provided for @not_synced.
  ///
  /// In en, this message translates to:
  /// **'Not Synced'**
  String get not_synced;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// No description provided for @menu_order_title.
  ///
  /// In en, this message translates to:
  /// **'Menu Order'**
  String get menu_order_title;

  /// No description provided for @table_management_title.
  ///
  /// In en, this message translates to:
  /// **'Table Management'**
  String get table_management_title;

  /// No description provided for @history_title.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history_title;

  /// No description provided for @printer_title.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get printer_title;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @pos_resto_title.
  ///
  /// In en, this message translates to:
  /// **'POS Resto'**
  String get pos_resto_title;

  /// No description provided for @logout_success.
  ///
  /// In en, this message translates to:
  /// **'Logout success'**
  String get logout_success;

  /// No description provided for @sync_settings_success.
  ///
  /// In en, this message translates to:
  /// **'Sync settings success'**
  String get sync_settings_success;

  /// No description provided for @sync_settings_failed.
  ///
  /// In en, this message translates to:
  /// **'Sync settings failed'**
  String get sync_settings_failed;

  /// No description provided for @syncing_settings.
  ///
  /// In en, this message translates to:
  /// **'Syncing settings...'**
  String get syncing_settings;

  /// No description provided for @choose_photo.
  ///
  /// In en, this message translates to:
  /// **'Choose Photo'**
  String get choose_photo;

  /// No description provided for @item_sales_report_title.
  ///
  /// In en, this message translates to:
  /// **'Item Sales Report'**
  String get item_sales_report_title;

  /// No description provided for @company_address_value.
  ///
  /// In en, this message translates to:
  /// **'Jalan Melati No. 12, Mranggen, Demak, Central Java, 89568'**
  String get company_address_value;

  /// No description provided for @normal_price.
  ///
  /// In en, this message translates to:
  /// **'Normal Price'**
  String get normal_price;

  /// No description provided for @final_total.
  ///
  /// In en, this message translates to:
  /// **'Final Total'**
  String get final_total;

  /// No description provided for @transaction_id.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transaction_id;

  /// No description provided for @order_by.
  ///
  /// In en, this message translates to:
  /// **'Order By'**
  String get order_by;

  /// No description provided for @scan_qris_below.
  ///
  /// In en, this message translates to:
  /// **'Scan QRIS Below for Payment'**
  String get scan_qris_below;

  /// No description provided for @price_label.
  ///
  /// In en, this message translates to:
  /// **'Price : {price}'**
  String price_label(Object price);

  /// No description provided for @date_label.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get date_label;

  /// No description provided for @receipt_label.
  ///
  /// In en, this message translates to:
  /// **'Receipt:'**
  String get receipt_label;

  /// No description provided for @customer_label.
  ///
  /// In en, this message translates to:
  /// **'Customer:'**
  String get customer_label;

  /// No description provided for @cashier_label.
  ///
  /// In en, this message translates to:
  /// **'Cashier:'**
  String get cashier_label;

  /// No description provided for @table_label.
  ///
  /// In en, this message translates to:
  /// **'Table: {name}'**
  String table_label(Object name);

  /// No description provided for @subtotal_label.
  ///
  /// In en, this message translates to:
  /// **'Subtotal:'**
  String get subtotal_label;

  /// No description provided for @tax_label_receipt.
  ///
  /// In en, this message translates to:
  /// **'Tax ({percent}%):'**
  String tax_label_receipt(Object percent);

  /// No description provided for @service_label_receipt.
  ///
  /// In en, this message translates to:
  /// **'Service ({percent}%):'**
  String service_label_receipt(Object percent);

  /// No description provided for @total_label.
  ///
  /// In en, this message translates to:
  /// **'TOTAL:'**
  String get total_label;

  /// No description provided for @payment_label.
  ///
  /// In en, this message translates to:
  /// **'Payment ({method}):'**
  String payment_label(Object method);

  /// No description provided for @change_label.
  ///
  /// In en, this message translates to:
  /// **'Change:'**
  String get change_label;

  /// No description provided for @table_checker.
  ///
  /// In en, this message translates to:
  /// **'Table Checker'**
  String get table_checker;

  /// No description provided for @kitchen_title.
  ///
  /// In en, this message translates to:
  /// **'KITCHEN'**
  String get kitchen_title;

  /// No description provided for @bar_title.
  ///
  /// In en, this message translates to:
  /// **'Table Bar'**
  String get bar_title;

  /// No description provided for @completed_status.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed_status;

  /// No description provided for @paid_status.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid_status;

  /// No description provided for @cooking_status.
  ///
  /// In en, this message translates to:
  /// **'Cooking'**
  String get cooking_status;

  /// No description provided for @added_success.
  ///
  /// In en, this message translates to:
  /// **'Successfully added'**
  String get added_success;

  /// No description provided for @stock_insufficient_cart.
  ///
  /// In en, this message translates to:
  /// **'Stock insufficient! Available: {stock}, In cart: {cart}'**
  String stock_insufficient_cart(Object cart, Object stock);

  /// No description provided for @stock_verification_failed.
  ///
  /// In en, this message translates to:
  /// **'Cannot verify online stock. Added based on local stock.'**
  String get stock_verification_failed;

  /// No description provided for @premium_features.
  ///
  /// In en, this message translates to:
  /// **'Premium Features'**
  String get premium_features;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
