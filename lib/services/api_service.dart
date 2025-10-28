import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class Paged<T> {
  final List<T> items;
  final bool hasNext;
  final int page;
  const Paged({required this.items, required this.hasNext, required this.page});
}

class ApiService {
  static const _base = 'https://api.jikan.moe/v4';

  Future<Paged<Anime>> fetchTopAnime({int page = 1, int limit = 25}) async {
    final uri = Uri.parse('$_base/top/anime?page=$page&limit=$limit');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat Top: ${res.statusCode}');
    }
    final map = json.decode(res.body) as Map<String, dynamic>;
    final list = (map['data'] as List).cast<Map<String, dynamic>>();
    final hasNext = (map['pagination']?['has_next_page'] ?? false) as bool;
    final items = list.map((e) => Anime.fromListJson(e)).toList();
    return Paged(items: items, hasNext: hasNext, page: page);
  }

  Future<Paged<Anime>> searchAnime(String query, {int page = 1, int limit = 25}) async {
    final q = Uri.encodeQueryComponent(query);
    final uri = Uri.parse(
      '$_base/anime?q=$q&page=$page&limit=$limit&order_by=score&sort=desc&sfw=false',
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Gagal mencari: ${res.statusCode}');
    }
    final map = json.decode(res.body) as Map<String, dynamic>;
    final list = (map['data'] as List).cast<Map<String, dynamic>>();
    final hasNext = (map['pagination']?['has_next_page'] ?? false) as bool;
    final items = list.map((e) => Anime.fromListJson(e)).toList();
    return Paged(items: items, hasNext: hasNext, page: page);
  }

  /// Cari berdasarkan genre MAL/Jikan (mis. Action=1, Adventure=2, Comedy=4, Slice of Life=36)
  Future<Paged<Anime>> searchByGenre(int genreId, {int page = 1, int limit = 25}) async {
    final uri = Uri.parse(
      '$_base/anime?genres=$genreId&page=$page&limit=$limit&order_by=score&sort=desc&sfw=false',
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat genre: ${res.statusCode}');
    }
    final map = json.decode(res.body) as Map<String, dynamic>;
    final list = (map['data'] as List).cast<Map<String, dynamic>>();
    final hasNext = (map['pagination']?['has_next_page'] ?? false) as bool;
    final items = list.map((e) => Anime.fromListJson(e)).toList();
    return Paged(items: items, hasNext: hasNext, page: page);
  }

  Future<Anime> fetchDetail(int id) async {
    final uri = Uri.parse('$_base/anime/$id/full');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail: ${res.statusCode}');
    }
    final map = json.decode(res.body) as Map<String, dynamic>;
    final data = map['data'] as Map<String, dynamic>;
    return Anime.fromListJson(data);
  }
}
