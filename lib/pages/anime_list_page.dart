import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/anime.dart';
import '../widgets/anime_tile.dart';
import '../routes.dart';

const kCyan    = Color(0xFF00E5FF);
const kSurface = Color(0xFF13181B);

enum _Mode { top, search, genre }

class AnimeListPage extends StatefulWidget {
  const AnimeListPage({super.key});
  @override
  State<AnimeListPage> createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  final _api = ApiService();
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  final List<Anime> _items = [];
  _Mode _mode = _Mode.top;
  String _query = '';
  int? _genreId;
  String? _genreLabel;

  int _page = 1;
  bool _loading = false;
  bool _hasNext = true;
  Timer? _debounce;

  bool _initialized = false; // <-- cegah double load/race

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return; // hanya sekali

    final arg = ModalRoute.of(context)?.settings.arguments;

    // Jika datang dari CategoryChip (paket argumen Map)
    if (arg is Map) {
      final gId = arg['genreId'];
      final gLabel = arg['label'];
      if (gId is int) {
        _mode = _Mode.genre;
        _genreId = gId;
        _genreLabel = gLabel is String ? gLabel : null;
        _controller.text = _genreLabel?.toLowerCase() ?? '';
        _initialized = true;
        _loadFirst();
        return;
      }
    }

    // Kalau argumen String → jadikan query pencarian judul
    if (arg is String && arg.trim().isNotEmpty) {
      _mode = _Mode.search;
      _query = arg.trim();
      _controller.text = _query;
      _initialized = true;
      _loadFirst();
      return;
    }

    // Tidak ada argumen → tampilkan TOP
    _initialized = true;
    _loadFirst();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ===== Data Loaders =====
  Future<void> _loadFirst() async {
    setState(() {
      _items.clear();
      _page = 1;
      _hasNext = true;
    });
    await _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasNext) return;
    setState(() => _loading = true);

    try {
      Paged<Anime> pageResult;
      switch (_mode) {
        case _Mode.top:
          pageResult = await _api.fetchTopAnime(page: _page, limit: 25);
          break;
        case _Mode.search:
          pageResult = await _api.searchAnime(_query, page: _page, limit: 25);
          break;
        case _Mode.genre:
          pageResult = await _api.searchByGenre(_genreId ?? 1, page: _page, limit: 25);
          break;
      }
      if (!mounted) return;
      setState(() {
        _items.addAll(pageResult.items);
        _hasNext = pageResult.hasNext;
        _page += 1;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 240) {
      _loadMore();
    }
  }

  void _onChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _onSubmit(q));
  }

  void _onSubmit(String q) {
    final trimmed = q.trim();
    if (trimmed.isEmpty) {
      // kosong → balik ke TOP
      _mode = _Mode.top;
      _query = '';
      _genreId = null;
    } else {
      _mode = _Mode.search;
      _query = trimmed;
      _genreId = null;
    }
    _loadFirst();
  }

  @override
  Widget build(BuildContext context) {
    final title = _mode == _Mode.genre
        ? 'Genre: ${_genreLabel ?? _genreId}'
        : (_mode == _Mode.search ? 'Hasil: "$_query"' : 'Daftar Anime (Top)');

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              onSubmitted: _onSubmit,
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ketik judul anime…',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white70),
                  onPressed: () => _onSubmit(_controller.text),
                ),
                filled: true,
                fillColor: kSurface,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: kCyan),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: kCyan, width: 2),
                ),
              ),
            ),
          ),

          // Hasil
          Expanded(
            child: _items.isEmpty && _loading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                ? const _EmptyHint(text: 'Tidak ada data.')
                : ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _items.length + 1, // +1 loader bawah
              itemBuilder: (_, i) {
                if (i == _items.length) {
                  if (_loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _hasNext
                      ? const SizedBox.shrink()
                      : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text('— sudah semua —',
                          style: TextStyle(color: Colors.white60)),
                    ),
                  );
                }
                final a = _items[i];
                return AnimeTile(
                  anime: a,
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.detail,
                    arguments: a.malId,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;
  const _EmptyHint({this.text = 'Masukkan kata kunci untuk mencari anime.'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: const TextStyle(color: Colors.white60)),
    );
  }
}
