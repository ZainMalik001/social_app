import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';

class RubuAppbar extends StatelessWidget implements PreferredSizeWidget {
  final int? id;
  final bool? canPop, boldTitle;
  final List<String>? richTitle;
  final String? title;
  const RubuAppbar({super.key, this.id, this.canPop, this.boldTitle, this.richTitle, this.title})
      : assert((richTitle != null || title != null) && !(richTitle != null && title != null));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: (canPop ?? false)
          ? Center(
              child: Material(
                color: const Color(0xFF0A0F19),
                borderRadius: BorderRadius.circular(8.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () => Get.back(id: id),
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 12.0,
                      color: Color(0xFFF7ECDD),
                    ),
                  ),
                ),
              ),
            )
          : null,
      leadingWidth: 72.0,
      title: title == null
          ? Text.rich(
              TextSpan(children: [
                TextSpan(text: richTitle![0]),
                const TextSpan(text: ' - '),
                TextSpan(
                  text: richTitle![1],
                  style: GoogleFonts.jost(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ]),
              style: GoogleFonts.jost(
                fontSize: 16.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            )
          : Text(
              title!,
              style: (boldTitle ?? false)
                  ? GoogleFonts.jost(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )
                  : GoogleFonts.jost(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
            ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
