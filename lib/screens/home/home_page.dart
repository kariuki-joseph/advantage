import 'package:advantage/controllers/my_page_controller.dart';
import 'package:advantage/enums/tab_index.dart';
import 'package:advantage/screens/home/controller/home_page_controller.dart';
import 'package:advantage/screens/home/tabs/home_tab.dart';
import 'package:advantage/screens/home/tabs/messages_tab.dart';
import 'package:advantage/screens/home/tabs/my_ads_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController controller = Get.find();
  final MyPageController myPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: PageView(
            controller: myPageController.pageController,
            children: [
              const HomeTab(),
              MyAdsTab(),
              MessagesTab(),
            ],
            onPageChanged: (index) =>
                myPageController.currentIndex.value = TabIndex.values[index],
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
              currentIndex: myPageController.currentIndex.value.index,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_view_day),
                  label: "My Ads",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  label: "Message",
                )
              ],
              onTap: (index) =>
                  myPageController.setCurrentPage(TabIndex.values[index])),
        ),
      ),
    );
  }
}
