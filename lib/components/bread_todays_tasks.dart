import 'package:bread/services/settings/settings_controller.dart';
import 'package:flutter/material.dart';

class TodaysTasks extends StatelessWidget {
  const TodaysTasks({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: settingsController.hintState
              ? const Card(child: Text("Today"))
              : null,
        )
      ],
    );
  }
}
