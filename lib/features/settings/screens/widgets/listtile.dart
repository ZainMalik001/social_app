import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/settings_controller.dart';

class SettingsListTile extends StatelessWidget {
  final String label;
  const SettingsListTile({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (_) {
        return InkWell(
          onTap: () => _.toChangeScreen(label.split(' ').last),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.jost(fontSize: 16.0),
                ),
                Transform.rotate(
                  angle: -0.8,
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
