\# Tugas Mahasiswa



Aplikasi Android berbasis Flutter untuk mengelola tugas mahasiswa secara offline. Data disimpan di database SQLite lokal sehingga tugas tetap tersedia tanpa koneksi internet.



\## Fitur



\- Melihat daftar tugas dan memfilter berdasarkan status.

\- Menambah tugas melalui form.

\- Melihat detail dan mengedit tugas.

\- Menghapus tugas dengan konfirmasi.

\- Mengubah status tugas: Belum, Proses, atau Selesai.

\- Menyimpan mata kuliah, judul, deskripsi, deadline, prioritas, dan status.



\## Teknologi dan arsitektur



\- Flutter dan Dart untuk antarmuka aplikasi.

\- `sqflite` untuk database SQLite di perangkat.

\- Alur data: layar (`lib/screens`) → pengelola state (`lib/state`) → repository (`lib/data/task\_repository.dart`) → database (`lib/data/task\_database.dart`).



Layar tidak mengakses database secara langsung. Implementasi memakai Flutter sesuai arahan terbaru dosen, sebagai penyesuaian dari teknologi Kotlin/Compose/Room yang tertulis pada slide awal.



\## Cara menjalankan



Siapkan Flutter SDK, Android SDK, dan emulator atau HP Android. Dari folder proyek jalankan:



```bash

flutter pub get

flutter run

```



Untuk membuat APK:



```bash

flutter build apk --release

```



APK hasil build berada di `build/app/outputs/flutter-apk/app-release.apk`.



\## Cara menguji offline



1\. Tambahkan sebuah tugas dan ubah statusnya.

2\. Aktifkan mode pesawat.

3\. Tutup lalu buka ulang aplikasi.

4\. Periksa bahwa tugas dan status yang tersimpan masih tampil.



\## Dokumentasi layar



Screenshot daftar, tambah, detail, dan edit disimpan di folder `screenshots/`.

