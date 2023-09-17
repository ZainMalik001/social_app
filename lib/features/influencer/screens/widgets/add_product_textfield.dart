import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductTextField extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final String? hintText;
  final VoidCallback removeController;
  final void Function(int, String) addProduct;
  const AddProductTextField(
      {super.key,
      required this.index,
      required this.controller,
      this.hintText,
      required this.addProduct,
      required this.removeController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1.0,
                    color: Color(0xFF0A0F19),
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1.0,
                    color: Color(0xFF0A0F19),
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1.0,
                    color: Color(0xFF0A0F19),
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                labelText: hintText,
                labelStyle: GoogleFonts.jost(fontSize: 14.0, color: const Color(0x800A0F19)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              style: GoogleFonts.jost(fontSize: 14.0, color: const Color(0xFF0A0F19)),
              cursorColor: const Color(0xFF0A0F19),
            ),
          ),
          const SizedBox(width: 12.0),
          InkWell(
            borderRadius: BorderRadius.circular(24.0),
            onTap: () => addProduct(index, controller.text.trim()),
            child: const Icon(Icons.arrow_forward_rounded),
          ),
          // const SizedBox(width: 12.0),
          // InkWell(
          //   onTap: removeController,
          //   child: const Icon(
          //     Icons.close_rounded,
          //     color: Colors.red,
          //   ),
          // ),
        ],
      ),
    );
  }
}
