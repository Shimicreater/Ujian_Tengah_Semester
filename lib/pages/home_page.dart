import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/anime.dart';
import '../routes.dart';
import '../widgets/anime_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/category_chip.dart';
import '../widgets/poster_carousel.dart';
import '../widgets/h_hscroll_cards.dart';

// palet selaras main.dart
const kBgDark  = Color(0xFF0B0F10);
const kInkDark = Color(0xFF0B0F10);
const kSurface = Color(0xFF13181B);
const kCyan    = Color(0xFF00E5FF);

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api = ApiService();
  late Future<Paged<Anime>> _future; // pakai Paged<Anime>

  @override
  void initState() {
    super.initState();
    _future = _api.fetchTopAnime(page: 1, limit: 25);
  }

  void _goSearch() => Navigator.pushNamed(context, Routes.list);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Paged<Anime>>(
        future: _future,
        builder: (c, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) return Center(child: Text('Error: ${s.error}'));

          final data = s.data?.items ?? <Anime>[];
          final heroItems = data.take(6).toList();
          final trending  = data.skip(6).take(8).toList();

          return CustomScrollView(
            slivers: [
              // HERO: appbar gelap + carousel
              SliverAppBar(
                backgroundColor: kInkDark,
                foregroundColor: Colors.white,
                pinned: true,
                expandedHeight: 240,
                title: const Text('Re:Anime'),
                actions: [
                  IconButton(icon: const Icon(Icons.search), onPressed: _goSearch),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PosterCarousel(items: heroItems),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 80,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, kBgDark],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search pill
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: GestureDetector(
                    onTap: _goSearch,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: kSurface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: kCyan.withOpacity(.35), width: 1),
                        boxShadow: const [
                          BoxShadow(color: Colors.black54, blurRadius: 14, offset: Offset(0, 6)),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.white70),
                          SizedBox(width: 8),
                          Text('Cari judul anime…', style: TextStyle(color: Colors.white54)),
                          Spacer(),
                          Icon(Icons.tune, color: Colors.white70),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Kategori cepat → kirim genreId MAL/Jikan
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CategoryChip(icon: Icons.sports_martial_arts, label: 'Action',        genreId: 1),
                      CategoryChip(icon: Icons.explore_outlined,     label: 'Adventure',     genreId: 2),
                      CategoryChip(icon: Icons.self_improvement,     label: 'Slice of Life', genreId: 36),
                      CategoryChip(icon: Icons.emoji_emotions_outlined, label: 'Comedy',    genreId: 4),
                    ],
                  ),
                ),
              ),

              // Trending & Rekomendasi
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(title: 'Trending', onMore: _goSearch),
                ),
              ),
              SliverToBoxAdapter(child: HHScrollCards(items: heroItems)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: SectionHeader(title: 'Rekomendasi', onMore: _goSearch),
                ),
              ),
              SliverList.builder(
                itemCount: trending.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnimeTile(
                    anime: trending[i],
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.detail,
                      arguments: trending[i].malId,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          );
        },
      ),

      // NavigationBar cyan + ikon/label hitam
      bottomNavigationBar: NavigationBar(
        backgroundColor: kCyan,
        indicatorColor: Colors.transparent,
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.black),
            selectedIcon: Icon(Icons.home, color: Colors.black),
            label: 'Top',
          ),
          NavigationDestination(
            icon: Icon(Icons.search, color: Colors.black),
            selectedIcon: Icon(Icons.search, color: Colors.black),
            label: 'Cari',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline, color: Colors.black),
            selectedIcon: Icon(Icons.info, color: Colors.black),
            label: 'Tentang',
          ),
        ],
        onDestinationSelected: (i) {
          if (i == 1) _goSearch();
          if (i == 2) {
            showAboutDialog(
              context: context,
              applicationName: 'Re:Anime',
              applicationVersion: '1.0.0',
              children: const [Text('Rekomend Anime')],
            );
          }
        },
      ),
    );
  }
}
