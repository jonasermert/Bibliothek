import 'package:bibliothek/app/router.dart';
import 'package:bibliothek/core/theme/app_theme.dart';
import 'package:bibliothek/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BibliothekApp extends ConsumerWidget {
  const BibliothekApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Bibliothek',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      routerConfig: appRouter,
    );
  }
}
