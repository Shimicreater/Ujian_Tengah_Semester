import 'package:flutter/material.dart';
import '../models/anime.dart';

class AnimeTile extends StatelessWidget {
  final Anime anime;
  final VoidCallback onTap;
  const AnimeTile({super.key, required this.anime, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: anime.imageUrl != null
              ? Image.network(anime.imageUrl!, width: 56, height: 56, fit: BoxFit.cover)
              : const SizedBox(width: 56, height: 56),
        ),
        title: Text(anime.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('${anime.episodes ?? '-'} eps • ⭐ ${anime.score?.toStringAsFixed(1) ?? '-'}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
