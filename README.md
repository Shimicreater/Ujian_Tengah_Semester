# Re:Anime — Cari, Telusuri, Rekomendasi

**Link Repositori:** <https://github.com/Shimicreater/Ujian_Tengah_Semester.git>  

Re:Anime adalah aplikasi Flutter untuk mencari, menelusuri, dan mendapatkan rekomendasi anime. Aplikasi menampilkan Top Anime, pencarian judul, dan filter genre menggunakan **Jikan API (MyAnimeList Unofficial API)** dengan antarmuka bertema **black + cyan**.

---

##  Tema & Tujuan
- **Tema:** Katalog anime modern dengan UI mobile yang bersih dan responsif.
- **Tujuan:** Mempermudah pengguna menemukan anime berdasarkan peringkat, judul, atau genre, serta menjadi basis pengembangan lanjutan (favorit, auth, dsb).

---

##  Fitur Utama
- **Top Anime** di beranda.
- **Hero Carousel** pada header.
- **Category Chips (Genre)**: Action, Adventure, Slice of Life, Comedy (bisa ditambah).
- **Pencarian Judul** (debounce ±500ms).
- **Infinite Scroll** (Top, Search, Genre).
- **Halaman Detail**: poster, metadata, dan sinopsis.
- **NavigationBar cyan** (ikon & label hitam).

---

##  Struktur Proyek (ringkas)
lib/
main.dart
routes.dart
models/
anime.dart
services/
api_service.dart
pages/
home_page.dart
anime_list_page.dart
anime_detail_page.dart
widgets/
anime_tile.dart
poster_carousel.dart
h_hscroll_cards.dart
category_chip.dart
section_header.dart


---

##  Daftar Halaman & Fungsinya
- **HomePage (`/`)**
    - SliverAppBar + Hero Carousel.
    - Search pill → ke halaman pencarian.
    - Category Chips → buka daftar **per genre**.
    - Seksi “Trending” (horizontal) & “Rekomendasi” (list).

- **AnimeListPage (`/list`)**
    - **Mode:** `Top`, `Search (judul)`, `Genre`.
    - TextField pencarian + tombol submit.
    - **Infinite scroll** (load more).
    - **Arguments:**
        - `String` → query judul.
        - `Map{ genreId:int, label:String }` → filter genre (ID MAL/Jikan, mis. Action=1, Adventure=2, Comedy=4, Slice of Life=36).

- **AnimeDetailPage (`/detail`)**
    - Poster, judul, skor, episode, tahun/season.
    - Sinopsis dengan tombol “Selengkapnya/Sembunyikan”.

---

##  API yang Dipakai
- **Jikan API v4** — <https://api.jikan.moe/v4>  
  Endpoint:
    - `GET /top/anime?page=&limit=`
    - `GET /anime?q=&page=&limit=&order_by=score&sort=desc`
    - `GET /anime?genres=&page=&limit=&order_by=score&sort=desc`
    - `GET /anime/{id}/full`

> **Catatan:** Jikan punya rate limit. Jika dapat **HTTP 429**, tunggu beberapa detik lalu coba lagi.

---

## ️ Teknologi
- Flutter (Dart, Material 3)
- `package:http` untuk request API
- Arsitektur sederhana: **Service → Model → UI**

---

##  Cara Menjalankan

### Prasyarat
- Flutter SDK **3.9.x** (atau versi yang kamu pakai saat coding)
- Android SDK / Xcode (emulator/device)
- Internet aktif

### Langkah
```bash
# 1) dowload project di github 
https://github.com/Shimicreater/Ujian_Tengah_Semester.git

# 2) buka file project yang berupa ZIP
buka file tersebut menggunkan android studio

# 3) Install dependency
flutter pub get

# 4) Jalankan
flutter run


catatan : usahakan menjalankan di emulator atau android
