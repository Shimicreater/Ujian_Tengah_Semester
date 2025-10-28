import 'package:flutter/material.dart';
import '../routes.dart';

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? query;   // opsional (gunakan kalau mau search judul)
  final int? genreId;    // opsional (gunakan kalau mau filter genre)
  final Color? bgColor;
  final Color? iconColor;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.label,
    this.query,
    this.genreId,
    this.bgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (genreId != null) {
          Navigator.pushNamed(context, Routes.list, arguments: {
            'genreId': genreId,
            'label': label,
          });
        } else if (query != null) {
          Navigator.pushNamed(context, Routes.list, arguments: query);
        } else {
          Navigator.pushNamed(context, Routes.list);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor ?? const Color(0xFF13181B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: (iconColor ?? Colors.cyanAccent).withOpacity(.35), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: iconColor ?? Colors.cyanAccent),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
