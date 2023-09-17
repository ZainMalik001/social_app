import 'package:country/country.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/currency_controller.dart';

class ChangeCurrencyScreen extends StatelessWidget {
  const ChangeCurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: Get.back,
          child: const Icon(
            Icons.close_rounded,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Select currency',
          style: GoogleFonts.jost(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<CurrencyController>(
        init: CurrencyController(),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              for (var country in Countries.values)
                InkWell(
                  onTap: () {},
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 0.5,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          country.currencyCode ?? '',
                          style: const TextStyle(fontSize: 28.0),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            country.isoShortName,
                            style: GoogleFonts.jost(fontSize: 16.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // if (_.selectedCountry == country.alpha3) const SizedBox(width: 8.0),
                        // if (_.selectedCountry == country.alpha3)
                        //   const Icon(
                        //     Icons.check_rounded,
                        //     color: Colors.green,
                        //   )
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
