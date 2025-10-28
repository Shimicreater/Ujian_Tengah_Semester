import 'package:flutter/material.dart';
import 'routes.dart';
import 'pages/home_page.dart';
import 'pages/anime_list_page.dart';
import 'pages/anime_detail_page.dart';

void main() => runApp(const ReAnimeApp());

// Palet global
const Color kBgDark  = Color(0xFF0B0F10); // hampir hitam
const Color kInkDark = Color(0xFF0B0F10); // appbar/hero
const Color kSurface = Color(0xFF13181B); // kartu/search pill
const Color kCyan    = Color(0xFF00E5FF); // aksen

class ReAnimeApp extends StatelessWidget {
  const ReAnimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Re:Anime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: kBgDark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: kCyan,
          onPrimary: Colors.black,
          secondary: kCyan,
          onSecondary: Colors.black,
          error: Colors.redAccent,
          onError: Colors.white,
          background: kBgDark,
          onBackground: Colors.white,
          surface: kSurface,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kInkDark,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: kCyan,
          indicatorColor: Colors.transparent,
        ),
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (_) => const HomePage(),
        Routes.list: (_) => const AnimeListPage(),
        Routes.detail: (_) => const AnimeDetailPage(),
      },
    );
  }
}
