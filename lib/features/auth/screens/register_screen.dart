import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/core/enums.dart';
import 'package:rubu/features/auth/controllers/register_controller.dart';
import 'package:rubu/features/auth/screens/widgets/textfield.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: Get.arguments != null && Get.arguments.containsKey('isDialog') && Get.arguments['isDialog']
              ? AppBar(
                  leading: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: Get.back,
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.black,
                    ),
                  ),
                  leadingWidth: 64.0,
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                )
              : null,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                Text(
                  'Signup',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Fill out the essential information to create your account',
                  style: GoogleFonts.jost(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 36.0),
                GetBuilder<RegisterController>(
                  id: BuilderIDs.registerControllerFullNameTextField,
                  builder: (_) {
                    return CustomTextField(
                      controller: _.fullNameController,
                      hintText: 'Full name',
                      borderColor: Colors.black,
                      capitalization: TextCapitalization.words,
                      inputType: TextInputType.text,
                    );
                  },
                ),
                // const SizedBox(height: 16.0),
                // GetBuilder<RegisterController>(
                //   id: BuilderIDs.registerControllerUserNameTextField,
                //   builder: (_) {
                //     return CustomTextField(
                //       controller: _.userNameController,
                //       hintText: 'Username',
                //     );
                //   },
                // ),
                // const SizedBox(height: 16.0),
                // Row(
                //   children: [
                //     Expanded(
                //       child: GetBuilder<RegisterController>(
                //         id: BuilderIDs.registerControllerGenderDropDown,
                //         builder: (_) {
                //           return CustomDropdown<String>(
                //             onChange: (String value, int index) => _.setGender(value),
                //             dropdownButtonStyle: DropdownButtonStyle(
                //               backgroundColor: Colors.black,
                //               shape: RoundedRectangleBorder(
                //                   side: const BorderSide(width: 1.6, color: Color(0xFFF7ECDD)),
                //                   borderRadius: BorderRadius.circular(12.0)),
                //               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                //             ),
                //             dropdownStyle: DropdownStyle(
                //               color: Colors.black,
                //               borderRadius: BorderRadius.circular(12.0),
                //               padding: const EdgeInsets.symmetric(vertical: 8.0),
                //             ),
                //             items: [
                //               'Male',
                //               'Female',
                //               'Other',
                //             ]
                //                 .asMap()
                //                 .entries
                //                 .map(
                //                   (item) => DropdownItem<String>(
                //                     value: item.value,
                //                     child: Padding(
                //                       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                //                       child: Text(
                //                         item.value,
                //                         style: GoogleFonts.jost(fontSize: 20.0, color: const Color(0xFFF7ECDD)),
                //                         overflow: TextOverflow.ellipsis,
                //                         maxLines: 1,
                //                       ),
                //                     ),
                //                   ),
                //                 )
                //                 .toList(),
                //             child: Text(
                //               'Gender',
                //               style: GoogleFonts.jost(
                //                 fontSize: 22.0,
                //                 fontWeight: FontWeight.w400,
                //                 color: const Color(0x80F7ECDD),
                //               ),
                //             ),
                //           );
                //         },
                //       ),
                //     ),
                //     const SizedBox(width: 16.0),
                //     Expanded(
                //       child: GetBuilder<RegisterController>(
                //         id: BuilderIDs.registerControllerAgeGroupDropDown,
                //         builder: (_) {
                //           return CustomDropdown<String>(
                //             onChange: (String value, int index) => _.setAgeGroup(value),
                //             dropdownButtonStyle: DropdownButtonStyle(
                //               backgroundColor: Colors.black,
                //               shape: RoundedRectangleBorder(
                //                   side: const BorderSide(width: 1.6, color: Color(0xFFF7ECDD)),
                //                   borderRadius: BorderRadius.circular(12.0)),
                //               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                //             ),
                //             dropdownStyle: DropdownStyle(
                //               color: Colors.black,
                //               borderRadius: BorderRadius.circular(12.0),
                //               padding: const EdgeInsets.symmetric(vertical: 8.0),
                //             ),
                //             items: [
                //               '13-18',
                //               '19-25',
                //               '25-32',
                //             ]
                //                 .asMap()
                //                 .entries
                //                 .map(
                //                   (item) => DropdownItem<String>(
                //                     value: item.value,
                //                     child: Padding(
                //                       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                //                       child: Text(
                //                         item.value,
                //                         style: GoogleFonts.jost(fontSize: 20.0, color: const Color(0xFFF7ECDD)),
                //                         overflow: TextOverflow.ellipsis,
                //                         maxLines: 1,
                //                       ),
                //                     ),
                //                   ),
                //                 )
                //                 .toList(),
                //             child: Text(
                //               'Age Group',
                //               style: GoogleFonts.jost(
                //                 fontSize: 22.0,
                //                 fontWeight: FontWeight.w400,
                //                 color: const Color(0x80F7ECDD),
                //               ),
                //               overflow: TextOverflow.ellipsis,
                //               maxLines: 1,
                //             ),
                //           );
                //         },
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 16.0),
                // GetBuilder<RegisterController>(
                //   id: BuilderIDs.registerControllerMobileNumberTextField,
                //   builder: (_) {
                //     return CustomTextField(
                //       controller: _.phoneController,
                //       hintText: 'Mobile Number',
                //     );
                //   },
                // ),
                const SizedBox(height: 16.0),
                GetBuilder<RegisterController>(
                  id: BuilderIDs.registerControllerEmailTextField,
                  builder: (_) {
                    return CustomTextField(
                      controller: _.emailController,
                      hintText: 'Email',
                      borderColor: Colors.black,
                      capitalization: TextCapitalization.none,
                      inputType: TextInputType.emailAddress,
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                GetBuilder<RegisterController>(
                  id: BuilderIDs.registerControllerPasswordTextField,
                  builder: (_) {
                    return CustomTextField(
                      controller: _.passwordController,
                      hintText: 'Password',
                      allowObscure: true,
                      obscured: true,
                      borderColor: Colors.black,
                    );
                  },
                ),
                const SizedBox(height: 24.0),
                Material(
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 2.0),
                      GetBuilder<RegisterController>(
                        init: RegisterController(),
                        builder: (_) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(6.0),
                            onTap: _.toggleAgreement,
                            child: Ink(
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  width: 2.0,
                                  color: Colors.black,
                                ),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: _.agreed ? Colors.black : Colors.white,
                                size: 16.0,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'I agree to the ',
                              style: GoogleFonts.jost(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              splashFactory: NoSplash.splashFactory,
                              highlightColor: Colors.transparent,
                              child: Text(
                                'terms of user',
                                style: GoogleFonts.jost(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(
                              ' and ',
                              style: GoogleFonts.jost(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              splashFactory: NoSplash.splashFactory,
                              highlightColor: Colors.transparent,
                              child: Text(
                                'privacy policy',
                                style: GoogleFonts.jost(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36.0),
                GetBuilder<RegisterController>(
                  builder: (_) {
                    return Material(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: _.createUserWithEmailPassword,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                                  'Create an Account',
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1.0,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Text(
                      'OR',
                      style: GoogleFonts.jost(
                        fontSize: 12.0,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Container(
                        height: 1.0,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Material(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1.6, color: Colors.black),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: Get.find<RegisterController>().signInWithGoogle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      child: Row(
                        children: [
                          Image.asset('assets/images/auth/google.png', width: 24.0, height: 24.0),
                          const SizedBox(width: 16.0),
                          Text(
                            'Continue with Google',
                            style: GoogleFonts.jost(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Material(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1.6, color: Colors.black),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: Get.find<RegisterController>().signInWithApple,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      child: Row(
                        children: [
                          Image.asset('assets/images/auth/apple.png', width: 24.0, height: 24.0),
                          const SizedBox(width: 16.0),
                          Text(
                            'Continue with Apple',
                            style: GoogleFonts.jost(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Material(
                //       type: MaterialType.transparency,
                //       shape: RoundedRectangleBorder(
                //         side: const BorderSide(width: 1.0, color: Colors.black),
                //         borderRadius: BorderRadius.circular(12.0),
                //       ),
                //       child: InkWell(
                //         borderRadius: BorderRadius.circular(12.0),
                //         onTap: Get.find<RegisterController>().signInWithGoogle,
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                //           child: Image.asset('assets/images/auth/google.png', width: 24.0, height: 24.0),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 16.0),
                //     Material(
                //       type: MaterialType.transparency,
                //       shape: RoundedRectangleBorder(
                //         side: const BorderSide(width: 1.0, color: Colors.black),
                //         borderRadius: BorderRadius.circular(12.0),
                //       ),
                //       child: InkWell(
                //         borderRadius: BorderRadius.circular(12.0),
                //         onTap: Get.find<RegisterController>().signInWithApple,
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                //           child: Image.asset('assets/images/auth/apple.png', width: 24.0, height: 24.0),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 32.0),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.jost(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: Get.arguments != null && Get.arguments.containsKey('isDialog') && Get.arguments['isDialog']
                          ? () => Get.offNamed('/loginDialog', arguments: {'isDialog': true})
                          : () => Get.offNamed("/login"),
                      child: Text(
                        'Login',
                        style: GoogleFonts.jost(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
