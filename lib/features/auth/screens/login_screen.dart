import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/core/enums.dart';
import 'package:rubu/features/auth/controllers/login_controller.dart';
import 'package:rubu/features/auth/screens/widgets/textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          body: ListView(
            children: [
              // Container(
              //   height: 200.0,
              //   margin: const EdgeInsets.symmetric(horizontal: 12.0),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         flex: 2,
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.stretch,
              //           children: [
              //             Expanded(
              //               child: Row(
              //                 crossAxisAlignment: CrossAxisAlignment.stretch,
              //                 children: [
              //                   Expanded(
              //                     child: ClipRRect(
              //                       borderRadius: BorderRadius.circular(12.0),
              //                       child: Image.asset(
              //                         'assets/images/welcome/3.png',
              //                         fit: BoxFit.cover,
              //                       ),
              //                     ),
              //                   ),
              //                   const SizedBox(width: 8.0),
              //                   Expanded(
              //                     flex: 2,
              //                     child: ClipRRect(
              //                       borderRadius: BorderRadius.circular(12.0),
              //                       child: Image.asset(
              //                         'assets/images/welcome/4.png',
              //                         fit: BoxFit.cover,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             const SizedBox(height: 8.0),
              //             Expanded(
              //               child: ClipRRect(
              //                 borderRadius: BorderRadius.circular(12.0),
              //                 child: Image.asset(
              //                   'assets/images/welcome/6.png',
              //                   fit: BoxFit.cover,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       const SizedBox(width: 8.0),
              //       Expanded(
              //         flex: 1,
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.stretch,
              //           children: [
              //             Expanded(
              //               flex: 3,
              //               child: ClipRRect(
              //                 borderRadius: BorderRadius.circular(12.0),
              //                 child: Image.asset(
              //                   'assets/images/welcome/5.png',
              //                   fit: BoxFit.cover,
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(height: 8.0),
              //             Expanded(
              //               child: ClipRRect(
              //                 borderRadius: BorderRadius.circular(10.0),
              //                 child: Image.asset(
              //                   'assets/images/welcome/7.png',
              //                   fit: BoxFit.cover,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/images/auth/login.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Login',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Fill out the essential information to Login',
                      style: GoogleFonts.jost(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 28.0),
                    GetBuilder<LoginController>(
                      id: BuilderIDs.loginControllerEmailTextField,
                      builder: (_) {
                        return CustomTextField(
                          controller: _.emailController,
                          hintText: 'Email',
                          borderColor: Colors.black,
                          inputType: TextInputType.emailAddress,
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    GetBuilder<LoginController>(
                      id: BuilderIDs.loginControllerPasswordTextField,
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
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => Get.toNamed('/forgot'),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.jost(
                              fontSize: 14.0,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36.0),
                    GetBuilder<LoginController>(
                      id: 'loginButton',
                      builder: (_) {
                        return Material(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.black,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16.0),
                            onTap: _.signInWithEmailPassword,
                            // onTap: () => Get.toNamed('/home'),
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
                                      'Login',
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Material(
                    //       type: MaterialType.transparency,
                    //       shape: RoundedRectangleBorder(
                    //         side: const BorderSide(
                    //           width: 1.0,
                    //           color: Colors.black,
                    //         ),
                    //         borderRadius: BorderRadius.circular(12.0),
                    //       ),
                    //       child: InkWell(
                    //         borderRadius: BorderRadius.circular(12.0),
                    //         onTap: Get.find<LoginController>().signInWithGoogle,
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
                    //         side: const BorderSide(
                    //           width: 1.0,
                    //           color: Colors.black,
                    //         ),
                    //         borderRadius: BorderRadius.circular(12.0),
                    //       ),
                    //       child: InkWell(
                    //         borderRadius: BorderRadius.circular(12.0),
                    //         onTap: Get.find<LoginController>().signInWithApple,
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    //           child: Image.asset('assets/images/auth/apple.png', width: 24.0, height: 24.0),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 16.0),
                    Material(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1.6, color: Colors.black),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: Get.find<LoginController>().signInWithGoogle,
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
                        onTap: Get.find<LoginController>().signInWithApple,
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
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: GoogleFonts.jost(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: Get.arguments != null && Get.arguments.containsKey('isDialog') && Get.arguments['isDialog']
                        ? () => Get.offNamed('/registerDialog', arguments: {'isDialog': true})
                        : () => Get.offNamed('/register'),
                    child: Text(
                      'Signup',
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
    );
  }
}
