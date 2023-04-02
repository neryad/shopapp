import 'package:PocketList/Lists/new-list-page.dart';
import 'package:PocketList/export-import/export-import-page.dart';
import 'package:PocketList/home/home_page.dart';
import 'package:PocketList/info/info_page.dart';
import 'package:PocketList/news/news_page.dart';
import 'package:PocketList/settings/settings_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/new-list',
    builder: (context, state) => const ListPage(),
  ),
  GoRoute(
    path: '/export-import',
    builder: (context, state) => const ExportImportPage(),
  ),
  GoRoute(
    path: '/settings',
    builder: (context, state) => const SettingsPages(),
  ),
  GoRoute(
    path: '/news-page',
    builder: (context, state) => const NewsPage(),
  ),
  GoRoute(
    path: '/info-page',
    builder: (context, state) => const InfoPage(),
  ),
]);
