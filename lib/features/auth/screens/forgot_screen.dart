import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/auth/controllers/forgot_controller.dart';
import 'package:rubu/features/auth/screens/widgets/textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Forgot Password',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 40.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24.0),
            CustomTextField(
              controller: Get.find<ForgotPasswordController>().textEditingController,
              hintText: 'Email Address',
              borderColor: Colors.black,
            ),
            const SizedBox(height: 24.0),
            GetBuilder<ForgotPasswordController>(
              builder: (_) {
                return InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: _.sendResetPassEmail,
                  // onTap: () => Get.toNamed('/home'),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: _.loading
                        ? const Center(
                            child: SizedBox(
                              width: 26.0,
                              height: 26.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Reset',
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
