// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get menu => 'Menu';

  @override
  String get orders => 'Pesanan';

  @override
  String get history => 'Riwayat';

  @override
  String get settings => 'Pengaturan';

  @override
  String get search_placeholder => 'Cari...';

  @override
  String get cart_title => 'Keranjang';

  @override
  String get total => 'Total';

  @override
  String get checkout => 'Bayar';

  @override
  String get success => 'Berhasil';

  @override
  String get error => 'Gagal';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get please_wait => 'Mohon tunggu';

  @override
  String get login => 'Masuk';

  @override
  String get logout => 'Keluar';

  @override
  String get email => 'Email';

  @override
  String get password => 'Kata Sandi';

  @override
  String get payment_success => 'Pembayaran Berhasil!';

  @override
  String get payment_failed => 'Pembayaran Gagal';

  @override
  String get items => 'Item';

  @override
  String get tax => 'Pajak';

  @override
  String get service_charge => 'Biaya Layanan';

  @override
  String get discount => 'Diskon';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get change => 'Kembalian';

  @override
  String get cash => 'Tunai';

  @override
  String get qris => 'QRIS';

  @override
  String get print_receipt => 'Cetak Struk';

  @override
  String get new_order => 'Pesanan Baru';

  @override
  String get sync_data => 'Sinkronisasi Data';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get about => 'Tentang & Bantuan';

  @override
  String get language => 'Bahasa';

  @override
  String get select_language => 'Pilih Bahasa';

  @override
  String get app_info => 'Info Aplikasi';

  @override
  String get server_sync => 'Sinkronisasi Server';

  @override
  String get preferences => 'Preferensi';

  @override
  String get from => 'Dari';

  @override
  String get to => 'Sampai';

  @override
  String get alerts => 'PERINGATAN';

  @override
  String low_stock_count(Object count) {
    return '$count produk stok menipis';
  }

  @override
  String pending_orders_count(Object count) {
    return '$count pesanan tertunda';
  }

  @override
  String get upgrade_premium_desc => 'Upgrade ke Premium untuk:';

  @override
  String get view_dashboard => 'Lihat Dashboard';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get no_items => 'Tidak Ada Item';

  @override
  String get stock_insufficient => 'Stok Tidak Cukup';

  @override
  String get ok => 'OK';

  @override
  String get no_tax_available => 'Tidak ada pajak tersedia';

  @override
  String get no_discount_available => 'Tidak ada diskon tersedia';

  @override
  String get no_service_available => 'Tidak ada layanan tersedia';

  @override
  String get no_table_data => 'Tidak ada data meja';

  @override
  String get welcome_dashboard => 'Selamat Datang di Dashboard';

  @override
  String error_loading_categories_msg(Object message) {
    return 'Gagal memuat kategori: $message';
  }

  @override
  String get select_table => 'Pilih Meja';

  @override
  String get search_table => 'Cari meja...';

  @override
  String get no_table_available => 'Tidak ada meja tersedia';

  @override
  String get select_tax => 'Pilih Pajak';

  @override
  String get no_tax => 'Tanpa Pajak';

  @override
  String get no_tax_desc => 'Tidak menggunakan pajak';

  @override
  String get tax_applied => 'Pajak berhasil diterapkan';

  @override
  String get select_discount => 'Pilih Diskon';

  @override
  String get no_discount => 'Tanpa Diskon';

  @override
  String get no_discount_desc => 'Tidak menggunakan diskon';

  @override
  String get discount_applied => 'Diskon berhasil diterapkan';

  @override
  String get select_service => 'Pilih Layanan';

  @override
  String get no_service => 'Tanpa Layanan';

  @override
  String get no_service_desc => 'Tidak menggunakan biaya layanan';

  @override
  String service_applied(Object name) {
    return 'Layanan $name diterapkan';
  }

  @override
  String get save => 'Simpan';

  @override
  String get all_categories => 'Semua Kategori';

  @override
  String get order_number => 'Pesanan#';

  @override
  String get order_note_label => 'Catatan Pesanan:';

  @override
  String get order_note_hint => 'Tambahkan catatan untuk dapur...';

  @override
  String refresh_error(Object count, Object message) {
    return 'Gagal menyegarkan $count item:\n$message';
  }

  @override
  String refresh_failed(Object message) {
    return 'Penyegaran gagal: $message';
  }

  @override
  String get qty => 'Jml';

  @override
  String get price => 'Harga';

  @override
  String get proceed_payment => 'Lanjutkan Pembayaran';

  @override
  String stock_validation_failed(Object message) {
    return 'Gagal validasi stok: $message';
  }

  @override
  String get select_table_dine_in => 'Pilih meja terlebih dahulu untuk Dine In';

  @override
  String get stock_insufficient_title => 'Stok Tidak Cukup';

  @override
  String get stock_insufficient_message => 'Stok tidak cukup';

  @override
  String get table_selected => 'Meja Dipilih';

  @override
  String get takeaway_no_table => 'Bungkus (Tanpa Meja)';

  @override
  String get tap_to_select_table => 'Ketuk untuk pilih meja';

  @override
  String get no_table_needed => 'Tidak perlu pilih meja';

  @override
  String get dine_in => 'Makan di Tempat';

  @override
  String get takeaway => 'Bungkus';

  @override
  String get history_orders => 'Riwayat Pesanan';

  @override
  String get filter_date_range => 'Filter Rentang Tanggal';

  @override
  String get start_date => 'Tanggal Mulai';

  @override
  String get end_date => 'Tanggal Akhir';

  @override
  String get select_start_date => 'Pilih Tanggal Mulai';

  @override
  String get select_end_date => 'Pilih Tanggal Akhir';

  @override
  String get clear_filter => 'Hapus Filter';

  @override
  String get apply_filter => 'Terapkan Filter';

  @override
  String get filter_active => 'Filter Aktif';

  @override
  String get filter_by_date => 'Filter berdasarkan Tanggal';

  @override
  String get update_status => 'Perbarui Status';

  @override
  String get start_cooking_confirm => 'Mulai Memasak?';

  @override
  String get mark_complete_confirm => 'Tandai Selesai?';

  @override
  String get order_note => 'Catatan Pesanan:';

  @override
  String get printing_receipt => 'Mencetak struk...';

  @override
  String get no_printer_found => 'Printer tidak ditemukan';

  @override
  String error_printing(Object message) {
    return 'Gagal mencetak: $message';
  }

  @override
  String get loading_data => 'Memuat data...';

  @override
  String get error_loading_orders => 'Gagal memuat pesanan';

  @override
  String get dashboard_title => 'Dashboard';

  @override
  String get avg_order => 'Rata-rata';

  @override
  String get customers => 'Pelanggan';

  @override
  String get delivery => 'Delivery';

  @override
  String get total_caps => 'TOTAL';

  @override
  String get transaction_report => 'Laporan Transaksi';

  @override
  String get item_sales_report => 'Laporan Penjualan Item';

  @override
  String get product_sales_chart => 'Grafik Penjualan Produk';

  @override
  String get summary_sales_report => 'Ringkasan Penjualan';

  @override
  String get confirm_payment => 'Konfirmasi Pembayaran';

  @override
  String get enter_customer_name => 'Masukkan nama pelanggan';

  @override
  String get qr_data_empty => 'Error: Data QR Kosong';

  @override
  String get order_note_example => 'Contoh: Jangan pedas, Es sedikit';

  @override
  String get email_address => 'Alamat Email';

  @override
  String get sign_in => 'Masuk';

  @override
  String get clear => 'Bersihkan';

  @override
  String get done => 'Selesai';

  @override
  String get print => 'Cetak';

  @override
  String get receipt => 'Struk';

  @override
  String get back => 'Kembali';

  @override
  String get print_checker => 'Cetak Checker';

  @override
  String get new_order_received => 'Pesanan Baru Diterima! Riwayat Diperbarui.';

  @override
  String get order_summary => 'Ringkasan Pesanan';

  @override
  String get item => 'Item';

  @override
  String get payment_details => 'Rincian Pembayaran';

  @override
  String get customer_name => 'Nama Pelanggan';

  @override
  String get payment_method => 'Metode Pembayaran';

  @override
  String get cash_amount => 'Jumlah Tunai';

  @override
  String get exact_amount => 'Uang Pas';

  @override
  String get customer_name_required => 'Nama pelanggan wajib diisi!';

  @override
  String get customer_name_required_takeaway =>
      'Nama pelanggan wajib diisi untuk Takeaway!';

  @override
  String get payment_amount_insufficient => 'Nominal pembayaran kurang!';

  @override
  String get payment_qris => 'Pembayaran QRIS';

  @override
  String get scan_qris => 'Scan QRIS untuk membayar';

  @override
  String get print_qris => 'Cetak QRIS';

  @override
  String get item_note => 'Catatan Item';

  @override
  String get max_chars => 'Maksimal 100 karakter';

  @override
  String get add_note => 'Tambah Catatan';

  @override
  String get order_type => 'Tipe Pesanan';

  @override
  String get total_bill => 'Total Tagihan';

  @override
  String get payment_amount => 'Nominal Bayar';

  @override
  String get money_insufficient => '⚠️ Uang kurang!';

  @override
  String get payment_time => 'Waktu Pembayaran';

  @override
  String get generating_pdf => 'Membuat PDF...';

  @override
  String get receipt_shared_success => 'Struk berhasil dibagikan!';

  @override
  String error_sharing_receipt(Object error) {
    return 'Gagal membagikan struk: $error';
  }

  @override
  String get order_saved_success => 'Pesanan Berhasil Disimpan';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get network => 'Network';

  @override
  String get size_58mm => '58 mm';

  @override
  String get size_80mm => '80 mm';

  @override
  String get printer_name => 'Nama Printer';

  @override
  String get printer_address => 'Alamat';

  @override
  String get test_print => 'Tes Print';

  @override
  String get search_food_placeholder => 'Cari makanan, kopi, dll..';

  @override
  String get search_tables => 'Cari meja...';

  @override
  String get search_generic => 'Cari';

  @override
  String get coming_soon => 'Segera Hadir';

  @override
  String get customer_name_hint => 'Nama Pelanggan';

  @override
  String get total_price_hint => 'Total Harga';

  @override
  String get close => 'Tutup';

  @override
  String get manage_printer => 'Kelola Printer';

  @override
  String get no_data_available => 'Data tidak tersedia';

  @override
  String get notification_preview => 'Ini adalah tampilan notifikasi';

  @override
  String get test_notification => 'Tes Notifikasi';

  @override
  String get ip_address => 'Alamat IP';

  @override
  String get paper_size => 'Ukuran Kertas';

  @override
  String get printer_type => 'Tipe Printer';

  @override
  String get sync_products_now => 'Sinkronisasi Produk Sekarang';

  @override
  String get sync_orders_now => 'Sinkronisasi Order Sekarang';

  @override
  String get status_available => 'Tersedia';

  @override
  String get tooltip_refresh_data => 'Segarkan Data';

  @override
  String get tooltip_print_receipt => 'Cetak Struk';

  @override
  String get tooltip_share_receipt => 'Bagikan Struk';

  @override
  String get tooltip_refresh_orders => 'Segarkan Pesanan';

  @override
  String get notification_sound => 'Suara Notifikasi';

  @override
  String get notification_sound_desc => 'Mainkan suara saat notifikasi masuk';

  @override
  String get new_order_alerts => 'Notifikasi Pesanan Baru';

  @override
  String get new_order_alerts_desc =>
      'Dapatkan notifikasi saat ada pesanan baru';

  @override
  String get low_stock_alerts => 'Notifikasi Stok Menipis';

  @override
  String get low_stock_alerts_desc =>
      'Dapatkan notifikasi saat stok produk menipis';

  @override
  String get menu_title => 'Menu';

  @override
  String new_order_body(Object count) {
    return 'Anda memiliki $count pesanan lunas.';
  }

  @override
  String get app_title => 'Aplikasi POS Resto';

  @override
  String get error_loading_categories => 'Gagal memuat kategori';

  @override
  String get discount_label => 'Diskon:';

  @override
  String get tax_label => 'Pajak';

  @override
  String get service_label => 'Layanan';

  @override
  String get push_notifications => 'Notifikasi Push';

  @override
  String get push_notifications_desc =>
      'Aktifkan atau nonaktifkan semua notifikasi push';

  @override
  String table_name_label(Object name) {
    return 'Meja $name';
  }

  @override
  String order_id_label(Object id) {
    return 'Pesanan #$id';
  }

  @override
  String get revenue => 'Pendapatan';

  @override
  String get sub_total => 'Sub Total';

  @override
  String get address => 'Alamat';

  @override
  String created_at(Object date) {
    return 'Dibuat Pada: $date';
  }

  @override
  String data_date(Object date) {
    return 'Data: $date';
  }

  @override
  String get report_title_summary => 'HayoPOS | Laporan Ringkasan Penjualan';

  @override
  String get report_title_transaction =>
      'HayoPOS | Laporan Transaksi Penjualan';

  @override
  String get time => 'Waktu';

  @override
  String feature_coming_soon(Object feature) {
    return '$feature akan tersedia pada pembaruan berikutnya.';
  }

  @override
  String get contact_support => 'Hubungi Dukungan';

  @override
  String get email_support => 'Email: support@posrestaurant.com';

  @override
  String get phone_support => 'Telepon: +62 123 4567 890';

  @override
  String get whatsapp_support => 'WhatsApp: +62 812 3456 7890';

  @override
  String get table_management => 'Manajemen Meja';

  @override
  String get table_layout => 'Tata Letak Meja';

  @override
  String get add_table => 'Tambah Meja';

  @override
  String get table_name_input => 'Nama Meja';

  @override
  String get add => 'Tambah';

  @override
  String get date => 'Tanggal';

  @override
  String get receipt_number => 'No. Resi';

  @override
  String get customer => 'Pelanggan';

  @override
  String get cashier => 'Kasir';

  @override
  String get table => 'Meja';

  @override
  String get self_order => 'Mandiri';

  @override
  String get note => 'Catatan';

  @override
  String subtotal_products(Object count) {
    return 'Subtotal $count Produk';
  }

  @override
  String tax_pb1(Object percent) {
    return 'Pajak PB1 ($percent%)';
  }

  @override
  String service_charge_receipt(Object percent) {
    return 'Layanan ($percent%)';
  }

  @override
  String payment_method_receipt(Object method) {
    return 'Pembayaran ($method)';
  }

  @override
  String paid_at(Object date) {
    return 'Dibayar pada: $date';
  }

  @override
  String printed_by(Object name) {
    return 'Dicetak oleh: $name';
  }

  @override
  String get thank_you => 'Terima kasih';

  @override
  String orders_table(Object name) {
    return 'Pesanan Meja $name';
  }

  @override
  String get payment => 'Pembayaran';

  @override
  String get total_payment => 'Total Bayar';

  @override
  String get pay => 'Bayar';

  @override
  String get sign_in_subtitle => 'Masuk untuk mengelola restoran Anda';

  @override
  String get welcome_back => 'Selamat Datang Kembali';

  @override
  String get copyright => '© 2025 HayoPOS. Hak cipta dilindungi undang-undang.';

  @override
  String get login_success => 'Berhasil Masuk';

  @override
  String get process_payment => 'Proses Pembayaran';

  @override
  String get sub_total_label => 'Sub Total';

  @override
  String get start_cooking => 'Mulai Masak';

  @override
  String get mark_complete => 'Tandai Selesai';

  @override
  String get walk_in => 'Walk-in';

  @override
  String get items_label => 'Item:';

  @override
  String get language_settings => 'Bahasa';

  @override
  String get sync_data_desc => 'Sinkronisasi data dari dan ke server';

  @override
  String get notifications_desc => 'Kelola preferensi notifikasi';

  @override
  String get about_desc => 'Info aplikasi dan dukungan';

  @override
  String get language_desc => 'Ubah bahasa aplikasi';

  @override
  String get kitchen_printer_title => 'Printer Dapur';

  @override
  String get bar_printer_title => 'Printer Bar';

  @override
  String get receipt_printer_title => 'Printer Struk';

  @override
  String get checker_printer_title => 'Printer Checker';

  @override
  String get paper_width => 'Lebar Kertas';

  @override
  String get search_printer_title => 'Cari Printer';

  @override
  String get bluetooth_enabled_msg =>
      'Bluetooth aktif, silakan cari dan hubungkan';

  @override
  String get bluetooth_not_enabled => 'Bluetooth tidak aktif';

  @override
  String get wait => 'Tunggu';

  @override
  String get no_bluetooth_linked =>
      'Tidak ada bluetooth terhubung, buka pengaturan dan hubungkan printer';

  @override
  String get touch_to_connect => 'Sentuh item dalam daftar untuk menghubungkan';

  @override
  String get connecting => 'Menghubungkan...';

  @override
  String get settings_saved => 'Pengaturan berhasil disimpan';

  @override
  String get printer_disconnected => 'Printer terputus';

  @override
  String get choose_size => 'Pilih Ukuran';

  @override
  String get choose_printer => 'Pilih Printer';

  @override
  String get printer_configuration_title => 'Konfigurasi Printer';

  @override
  String get receipt_tab => 'Struk';

  @override
  String get bill_receipt_desc => 'Tagihan & Struk';

  @override
  String get kitchen_tab => 'Dapur';

  @override
  String get food_orders_desc => 'Pesanan Makanan';

  @override
  String get bar_tab => 'Bar';

  @override
  String get drink_orders_desc => 'Pesanan Minuman';

  @override
  String get configuration_title => 'Konfigurasi';

  @override
  String get receipt_printer_desc => 'Untuk mencetak tagihan dan struk';

  @override
  String get kitchen_printer_desc => 'Untuk mencetak makanan ke dapur';

  @override
  String get bar_printer_desc => 'Untuk mencetak minuman ke bar';

  @override
  String error_message(Object message) {
    return 'Error: $message';
  }

  @override
  String get todays_performance => 'PERFORMA HARI INI';

  @override
  String get total_sales => 'Total Penjualan';

  @override
  String get order_types => 'TIPE PESANAN';

  @override
  String get top_3_products => '3 PRODUK TERATAS';

  @override
  String sold_count(Object count) {
    return '$count terjual';
  }

  @override
  String get unlock_full_analytics => 'BUKA ANALITIK LENGKAP';

  @override
  String get feature_profit_analysis => '✅ Analisis Keuntungan';

  @override
  String get feature_customer_insights => '✅ Wawasan Pelanggan';

  @override
  String get feature_sales_trends => '✅ Tren Penjualan (7-30 hari)';

  @override
  String get feature_export => '✅ Ekspor PDF/Excel';

  @override
  String get feature_advanced_reports => '✅ Laporan Lanjutan';

  @override
  String get free_trial_remaining =>
      'Anda memiliki 1 sisa tampilan uji coba GRATIS!';

  @override
  String get error_open_web => 'Tidak dapat membuka dashboard web';

  @override
  String get error_open_upgrade => 'Tidak dapat membuka halaman upgrade';

  @override
  String get summary_sales_report_title => 'Laporan Ringkasan Penjualan';

  @override
  String get id_col => 'ID';

  @override
  String get total_col => 'Total';

  @override
  String get sub_total_col => 'Sub Total';

  @override
  String get tax_col => 'Pajak';

  @override
  String get discount_col => 'Diskon';

  @override
  String get service_col => 'Layanan';

  @override
  String get total_item_col => 'Total Item';

  @override
  String get cashier_col => 'Kasir';

  @override
  String get time_col => 'Waktu';

  @override
  String get order_col => 'Pesanan';

  @override
  String get product_col => 'Produk';

  @override
  String get qty_col => 'Jml';

  @override
  String get price_col => 'Harga';

  @override
  String get total_price_col => 'Total Harga';

  @override
  String get app_name => 'HayoPOS';

  @override
  String get no_transactions => 'Belum ada transaksi saat ini.';

  @override
  String get customer_col => 'Pelanggan';

  @override
  String get status_col => 'Status';

  @override
  String get sync_col => 'Sinkron';

  @override
  String get payment_status_col => 'Status Pembayaran';

  @override
  String get payment_method_col => 'Metode Pembayaran';

  @override
  String get payment_amount_col => 'Jumlah Pembayaran';

  @override
  String get service_charge_col => 'Biaya Layanan';

  @override
  String get payment_col => 'Pembayaran';

  @override
  String get item_col => 'Item';

  @override
  String get action_col => 'Aksi';

  @override
  String get pdf_label => 'PDF';

  @override
  String get report_title => 'Laporan';

  @override
  String revenue_label(Object amount) {
    return 'PENDAPATAN : $amount';
  }

  @override
  String get not_synced => 'Belum';

  @override
  String get synced => 'Sudah';

  @override
  String get menu_order_title => 'Menu Pesanan';

  @override
  String get table_management_title => 'Manajemen Meja';

  @override
  String get history_title => 'Riwayat';

  @override
  String get printer_title => 'Printer';

  @override
  String get settings_title => 'Pengaturan';

  @override
  String get pos_resto_title => 'POS Resto';

  @override
  String get logout_success => 'Berhasil keluar';

  @override
  String get sync_settings_success => 'Sinkronisasi pengaturan berhasil';

  @override
  String get sync_settings_failed => 'Sinkronisasi pengaturan gagal';

  @override
  String get syncing_settings => 'Menyinkronkan pengaturan...';

  @override
  String get choose_photo => 'Pilih Foto';

  @override
  String get item_sales_report_title => 'Laporan Penjualan Item';

  @override
  String get company_address_value =>
      'Jalan Melati No. 12, Mranggen, Demak, Jawa Tengah, 89568';

  @override
  String get normal_price => 'Harga Normal';

  @override
  String get final_total => 'Total Akhir';

  @override
  String get transaction_id => 'ID Transaksi';

  @override
  String get order_by => 'Dipesan Oleh';

  @override
  String get scan_qris_below => 'Scan QRIS di Bawah untuk Pembayaran';

  @override
  String price_label(Object price) {
    return 'Harga : $price';
  }

  @override
  String get date_label => 'Tanggal:';

  @override
  String get receipt_label => 'Resi:';

  @override
  String get customer_label => 'Pelanggan:';

  @override
  String get cashier_label => 'Kasir:';

  @override
  String table_label(Object name) {
    return 'Meja: $name';
  }

  @override
  String get subtotal_label => 'Subtotal:';

  @override
  String tax_label_receipt(Object percent) {
    return 'Pajak ($percent%):';
  }

  @override
  String service_label_receipt(Object percent) {
    return 'Layanan ($percent%):';
  }

  @override
  String get total_label => 'TOTAL:';

  @override
  String payment_label(Object method) {
    return 'Pembayaran ($method):';
  }

  @override
  String get change_label => 'Kembalian:';

  @override
  String get table_checker => 'Pengecekan Meja';

  @override
  String get kitchen_title => 'DAPUR';

  @override
  String get bar_title => 'Bar Meja';

  @override
  String get completed_status => 'Selesai';

  @override
  String get paid_status => 'Dibayar';

  @override
  String get cooking_status => 'Dimasak';

  @override
  String get added_success => 'Berhasil ditambahkan';

  @override
  String stock_insufficient_cart(Object cart, Object stock) {
    return 'Stok tidak cukup! Tersedia: $stock, Di keranjang: $cart';
  }

  @override
  String get stock_verification_failed =>
      'Tidak dapat verifikasi stok online. Ditambahkan berdasarkan stok lokal.';
}
