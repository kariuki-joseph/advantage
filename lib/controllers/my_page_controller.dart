import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController {
  final PageController _pageController = PageController();
  final currentIndex = 0.obs;
  PageController get pageController => _pageController;

  void setCurrentPage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }
}
