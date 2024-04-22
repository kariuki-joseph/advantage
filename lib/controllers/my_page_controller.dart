import 'package:advantage/enums/tab_index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController {
  final PageController _pageController = PageController();
  final currentIndex = TabIndex.home.obs;
  PageController get pageController => _pageController;

  void setCurrentPage(TabIndex tabIndex) {
    currentIndex.value = tabIndex;
    pageController.animateToPage(
      tabIndex.index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }
}
