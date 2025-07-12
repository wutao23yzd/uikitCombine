import 'package:flutter/material.dart';


class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {

    return DropdownButton(
      key: const Key('themeSelector_dropdown'),
      onChanged: (ThemeMode? selectedThemeMode) {
      },
      value: ThemeMode.system,
      items: [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text(
            '跟随系统',
            key: const Key('themeSelector_system_dropdownMenuItem'),
          ),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text(
            '浅色模式',
            key: const Key('themeSelector_light_dropdownMenuItem'),
          ),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text(
            '深色模式',
            key: const Key('themeSelector_dark_dropdownMenuItem'),
          ),
        ),
      ],
    );
  }
}

class ThemeSelectorModalOption extends StatelessWidget {
  const ThemeSelectorModalOption({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const ThemeSelector(),
      title: Text("主题"),
    );
  }
}

class LocaleSelector extends StatelessWidget {
  const LocaleSelector({super.key});

  @override
  Widget build(BuildContext context) {
   
    return DropdownButton(
      key: const Key('localeSelector_dropdown'),
      onChanged: (locale) {

      },
      value: Locale('zh', 'ZH'),
      items: [
        DropdownMenuItem(
          value: const Locale('zh', 'ZH'),
          child: Text(
            '中文',
            key: const Key('localeSelector_en_dropdownMenuItem'),
          ),
        ),
        DropdownMenuItem(
          value: const Locale('en', 'US'),
          child: Text(
            'English',
            key: const Key('localeSelector_ru_dropdownMenuItem'),
          ),
        ),
      ],
    );
  }
}

class LocaleModalOption extends StatelessWidget {
  const LocaleModalOption({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const LocaleSelector(),
      title: Text("语言"),
    );
  }
}