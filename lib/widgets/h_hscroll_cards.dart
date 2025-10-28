import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../routes.dart';

class HHScrollCards extends StatelessWidget {
  final List<Anime> items;
  const HHScrollCards({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 172,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final a = items[i];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.detail, arguments: a.malId),
            child: SizedBox(
              width: 132,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: a.imageUrl != null
                          ? Image.network(a.imageUrl!, fit: BoxFit.cover, width: double.infinity)
                          : Container(color: Colors.black12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(a.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('${a.episodes ?? '-'} eps • ⭐ ${a.score?.toStringAsFixed(1) ?? '-'}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
