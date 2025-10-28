import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/anime.dart';

class AnimeDetailPage extends StatefulWidget {
  const AnimeDetailPage({super.key});

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  final _api = ApiService();
  Future<Anime>? _future;
  bool _expandSynopsis = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)!.settings.arguments as int;
    _future ??= _api.fetchDetail(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Anime>(
        future: _future,
        builder: (c, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) return Center(child: Text('Error: ${s.error}'));
          final a = s.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Poster
              if (a.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    a.imageUrl!,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: const Color(0xFF13181B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 48),
                ),

              const SizedBox(height: 16),
              // Judul
              Text(
                a.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),

              // Meta
              Text(
                '${a.year ?? '-'} ${a.season?.toUpperCase() ?? ''} • '
                    '${a.episodes ?? '-'} eps • ⭐ ${a.score?.toStringAsFixed(1) ?? '-'}',
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 16),


              Text(
                'Synopsis',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              AnimatedCrossFade(
                crossFadeState:
                _expandSynopsis ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
                firstChild: Text(
                  (a.synopsis ?? 'Tidak ada sinopsis.'),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                secondChild: Text(a.synopsis ?? 'Tidak ada sinopsis.'),
              ),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => setState(() => _expandSynopsis = !_expandSynopsis),
                  child: Text(_expandSynopsis ? 'Sembunyikan' : 'Selengkapnya'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
