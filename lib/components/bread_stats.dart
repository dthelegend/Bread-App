import 'package:bread/components/bread_main_view_tab.dart';
import 'package:bread/services/settings/settings_controller.dart';
import 'package:flutter/material.dart';

class Stats extends StatelessWidget implements BreadMainViewTab {
  const Stats({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Theme"),
            DropdownButton(
              value: settingsController.theme,
              items: ThemeMode.values
                  .map((theme) => DropdownMenuItem(
                        value: theme,
                        child: Text(theme.name),
                      ))
                  .toList(),
              onChanged: settingsController.setTheme,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Hints"),
            Switch(
                value: settingsController.hintState,
                onChanged: settingsController.setHintState)
          ],
        ),
      ],
    );
  }

  @override
  Widget? get floatingActionButton => null;

  @override
  Icon get icon => const Icon(Icons.line_axis);

  @override
  String get label => "Stats";
}
