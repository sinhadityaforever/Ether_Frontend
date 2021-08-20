import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/models/slider_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  List<SliderModel> slides = [];
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    slides = getSlides();
  }

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0.w),
      height: isCurrentPage ? 10.0.h : 6.0.h,
      width: isCurrentPage ? 10.0.w : 6.0.w,
      decoration: BoxDecoration(
        color: isCurrentPage ? Color(0xFFEB1555) : Colors.grey[800],
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView.builder(
          controller: pageController,
          itemCount: slides.length,
          onPageChanged: (val) {
            setState(() {
              currentIndex = val;
            });
          },
          itemBuilder: (context, index) {
            return SliderTile(
              assetImage: slides[index].getImageAssetPath(),
              title: slides[index].getTitle(),
              desc: slides[index].getDesc(),
              credit: slides[index].getCredits(),
            );
          },
        ),
        bottomSheet: currentIndex != slides.length - 1
            ? Container(
                color: Color(0xFF090E11),
                height: Platform.isIOS ? 70.h : 60.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Text(
                        "SKIP",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xFFEB1555),
                        ),
                      ),
                      onTap: () {
                        pageController.animateToPage(slides.length - 1,
                            duration: Duration(milliseconds: 80),
                            curve: Curves.linear);
                      },
                    ),
                    Row(
                      children: [
                        for (var i = 0; i < slides.length; i++)
                          currentIndex == i
                              ? pageIndexIndicator(true)
                              : pageIndexIndicator(false),
                      ],
                    ),
                    GestureDetector(
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {
                        pageController.animateToPage(
                          currentIndex + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear,
                        );
                      },
                    ),
                  ],
                ),
              )
            : Container(
                color: Color(0xFF090E11),
                height: Platform.isIOS ? 70.h : 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: GestureDetector(
                        child: Text(
                          "SIGN-IN",
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: GestureDetector(
                        child: Text(
                          "GET STARTED",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Color(0xFFEB1555),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/signupOTP');
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SliderTile extends StatelessWidget {
  String assetImage, title, desc, credit;
  SliderTile(
      {required this.assetImage,
      required this.title,
      required this.desc,
      required this.credit});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetImage, height: 350.h, width: 350.w),
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
            height: 60.h,
          ),
          Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEB1555),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 90.h,
          ),
          Container(
            decoration: BoxDecoration(
              color: credit != '' ? Colors.black26 : Color(0xFF0A0E21),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                credit,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Color(0xFFEB1555),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
