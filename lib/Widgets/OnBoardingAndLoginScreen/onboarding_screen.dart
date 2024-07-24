// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_constructors_in_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hilcoe_attendance_app/Widgets/OnBoardingAndLoginScreen/login_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/screen_colors.dart';
import 'Components/enter_id_overlay_screen.dart';
import 'Components/slide_one_onboarding.dart';
import 'Components/slide_three_onboarding.dart';
import 'Components/slide_two_onboarding.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageViewCtr = PageController();
  int currentPageIndex = 1;

  @override
  void initState() {
    super.initState();
    // Timer.periodic(Duration(seconds: 3), (_) {
    //   if (_currentPageIndex < 2) {
    //     _pageController.animateToPage(_currentPageIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.ease);
    //   } else {
    //     _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: MyColors.btnBgColor,
          width: double.infinity,
          height: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // double scrW = constraints.maxWidth;
              double scrH = constraints.maxHeight;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: scrH * 0.75,
                    child: PageView(
                      controller: _pageViewCtr,
                      children: [
                        SlideOneOnBoarding(),
                        SlideTwoOnBoarding(),
                        SlideThreeOnBoarding(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: scrH * 0.03,
                    child: SmoothPageIndicator(
                      controller: _pageViewCtr,
                      count: 3,
                      effect: ExpandingDotsEffect(activeDotColor: Colors.white, dotColor: Color.fromARGB(255, 190, 187, 187), dotHeight: 7, dotWidth: 7),
                    ),
                  ),
                  SizedBox(
                    height: scrH * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: "Don’t have an account? Contact the school system admin then register",
                            style: GoogleFonts.kumbhSans(color: Color.fromARGB(255, 226, 216, 251), fontSize: scrH * 0.02, fontWeight: FontWeight.w400),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' here',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(182, 226, 216, 251),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false, // set to false
                                        pageBuilder: (_, __, ___) => EnterIdOverLayScreen(),
                                        transitionsBuilder: (_, animation, __, child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0, 1), // start from bottom
                                              end: Offset.zero, // end at the center
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MyCustomButton(
                      backgroundColor: Colors.white,
                      txtColor: MyColors.btnBgColor,
                      btnText: "Log In",
                      btnHeight: scrH * 0.07,
                      btnOnTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginInScreen()),
                        );
                      },
                    ),
                  ),
                  // Container(
                  //   width: scrW,
                  //   height: scrH * 0.07,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 20),
                  //     child: ElevatedButton(
                  //       onPressed: () {},
                  //       style: ElevatedButton.styleFrom(
                  //         foregroundColor: Color.fromRGBO(48, 87, 184, 1),
                  //         backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(15),
                  //         ),
                  //         elevation: 3,
                  //       ),
                  //       child: Text(
                  //         'Login',
                  //         style: TextStyle(
                  //           fontSize: scrH * 0.027,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
