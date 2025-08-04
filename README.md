# Ruby Product Management System

Aplikasi web modern untuk manajemen produk dan riwayat pembelian yang dibangun dengan Ruby Sinatra dan Supabase database.

## 🚀 Fitur Utama

### 📦 Product Management
- **View Products**: Lihat semua produk dengan informasi lengkap dan statistik inventori
- **Add Product**: Tambah produk baru dengan nama, deskripsi, harga, dan stok
- **Edit Product**: Update informasi produk yang sudah ada
- **Delete Product**: Hapus produk dari inventori dengan konfirmasi
- **Real-time Stock**: Informasi stok yang diupdate secara otomatis

### 🛒 Purchase Tracking  
- **Create Purchase**: Buat transaksi pembelian baru dengan validasi stok
- **Stock Management**: Stok produk berkurang otomatis saat pembelian
- **Purchase Validation**: Validasi stok sebelum memproses pembelian
- **Total Calculation**: Kalkulasi total harga otomatis

### 📊 Purchase History
- **View History**: Lihat semua riwayat pembelian dengan detail lengkap
- **Cancel Purchase**: Batalkan pembelian dan kembalikan stok secara otomatis
- **Purchase Status**: Track status pembelian (completed/cancelled)
- **Summary Stats**: Statistik ringkasan transaksi dan penjualan

## 🛠️ Teknologi yang Digunakan

- **Backend**: Ruby 3.0+ dengan Sinatra framework
- **Database**: Supabase (PostgreSQL) dengan REST API
- **Frontend**: ERB templates dengan Tailwind CSS 3.x
- **Icons**: Font Awesome 6.0 untuk UI yang menarik
- **HTTP Client**: HTTParty untuk komunikasi dengan Supabase API
- **Server**: Puma web server untuk development

## 📋 Prerequisites

- Ruby 3.0 atau lebih baru
- Bundler gem untuk dependency management
- Akun Supabase (gratis) untuk database

## 🎯 Cara Penggunaan

### Dashboard Utama
- Overview fitur aplikasi
- Quick access ke semua fungsi utama
- Navigasi yang intuitif

### Manajemen Produk
1. **Tambah Produk**: Klik "Tambah Produk" → isi form → simpan
2. **Edit Produk**: Klik icon edit pada produk → update data → simpan  
3. **Hapus Produk**: Klik icon hapus → konfirmasi penghapusan

### Transaksi Pembelian
1. **Buat Pembelian**: Pilih produk → masukkan jumlah → konfirmasi
2. **Lihat Riwayat**: Menu "Pembelian" untuk melihat semua transaksi
3. **Batalkan Transaksi**: Klik "Batalkan" pada transaksi yang memenuhi syarat

## 🗂️ Struktur Project

```
task-ruby/
├── app.rb                 # Main Sinatra application
├── config.ru             # Rack configuration  
├── Gemfile               # Ruby dependencies
├── .env.example          # Environment variables template
├── simple_database_setup.sql # Database schema
└── views/
    ├── layout.erb        # Main layout template
    ├── index.erb         # Homepage dashboard
    ├── products.erb      # Products listing page
    ├── product_form.erb  # Add product form
    ├── product_edit.erb  # Edit product form  
    ├── purchases.erb     # Purchase history page
    └── purchase_form.erb # Create purchase form
```

## 🎨 UI/UX Features

- **Responsive Design**: Optimal di desktop, tablet, dan mobile
- **Modern Interface**: Clean design dengan Tailwind CSS
- **Interactive Elements**: Smooth hover effects dan transitions
- **Icon Integration**: Font Awesome icons untuk visual appeal
- **Color Coding**: Status indicators dengan warna yang intuitif
- **Form Validation**: Client-side dan server-side validation
- **Real-time Updates**: Dynamic content updates

## 🔧 API Endpoints

### Products
- `GET /products` - Lihat semua produk
- `GET /products/new` - Form tambah produk
- `POST /products` - Buat produk baru
- `GET /products/:id/edit` - Form edit produk
- `PATCH /products/:id` - Update produk
- `DELETE /products/:id` - Hapus produk

### Purchases  
- `GET /purchases` - Lihat riwayat pembelian
- `GET /purchases/new` - Form buat pembelian
- `POST /purchases` - Buat pembelian baru
- `PATCH /purchases/:id/cancel` - Batalkan pembelian

## 🔐 Security & Best Practices

- Environment variables untuk database credentials
- Input validation dan sanitization
- Proper error handling dan logging
- HTTPS ready untuk production
- CORS handling untuk API requests

### Production Deployment
- **Heroku**: Push ke Git repository dengan Heroku buildpack
- **Railway**: Connect GitHub repository dengan auto-deploy
- **Render**: Deploy dari Git dengan Ruby runtime
- **VPS**: Deploy dengan Nginx + Passenger atau Puma

## 🐛 Troubleshooting

### Database Connection Issues
- Pastikan SUPABASE_URL dan SUPABASE_KEY benar
- Verifikasi koneksi internet
- Cek Row Level Security policies di Supabase

## 📝 Contributing

1. Fork repository
2. Buat feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push ke branch (`git push origin feature/amazing-feature`)
5. Buat Pull Request

## 📄 License

MIT License - bebas digunakan untuk project personal maupun komersial.

---

**🎉 Selamat menggunakan Ruby Product Management System!**

Jika ada pertanyaan atau issues, silakan buat issue di repository ini.
