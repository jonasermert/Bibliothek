import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text('Einstellungen'),
          automaticallyImplyLeading: false,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList.list(
            children: [
              Card(
                child: RadioGroup<ThemeMode>(
                  groupValue: mode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeModeProvider.notifier).state = value;
                    }
                  },
                  child: const Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.system,
                        title: Text('Systemeinstellung'),
                        secondary: Icon(Icons.brightness_auto_rounded),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        title: Text('Hell'),
                        secondary: Icon(Icons.light_mode_rounded),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        title: Text('Dunkel'),
                        secondary: Icon(Icons.dark_mode_rounded),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text('Datenquelle'),
                  subtitle: Text(
                    'Buchdaten und Cover werden über die öffentliche '
                    'Open Library API geladen.',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
