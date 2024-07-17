import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iremflix/bottom_nav_bar.dart';
import 'package:iremflix/intro_screens/intro_page_1.dart';
import 'package:iremflix/intro_screens/intro_page_2.dart';
import 'package:iremflix/intro_screens/intro_page_3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  final TextEditingController nameController = TextEditingController();

  void _onNextPressed() {
    if (_controller.page == 0) {
      if (nameController.text.isNotEmpty) {
        _controller.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Please enter your name.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      _controller.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  void _onSkipPressed() {
    if (_controller.page == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'You are on the first page.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    } else if (_controller.page == 1) {
      _controller.jumpToPage(0);
    } else {
      _controller.jumpToPage(1);
    }
  }

  void _onDonePressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNavbar(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            physics: NeverScrollableScrollPhysics(),
            children: [
              IntroPage1(nameController: nameController),
              IntroPage2(name: nameController.text),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _onSkipPressed,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SmoothPageIndicator(controller: _controller, count: 3),
                GestureDetector(
                  onTap: onLastPage ? _onDonePressed : _onNextPressed,
                  child: Text(
                    onLastPage ? 'Done' : 'Next',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

