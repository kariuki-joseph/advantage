import 'package:advantage/constants/app_color.dart';
import 'package:advantage/screens/home/controller/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomePageController controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // search
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.searchBarBackground,
                        hintText: "Search",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide.none),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("images/user_avatar.png"),
                          ),
                        ),
                        suffixIcon: null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Body
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage("images/user_avatar.png"),
                              ),
                              title: Text(
                                "John Doe",
                                style: TextStyle(fontSize: 16),
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: AppColor.primaryColor,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Posted 1 hour",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.directions_run,
                                    size: 16,
                                    color: AppColor.primaryColor,
                                  ),
                                  Text(
                                    "1 Km",
                                    style: TextStyle(fontSize: 11),
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              "Bedsitter available",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "KES 6000",
                              style: TextStyle(fontSize: 16),
                            ),
                            // text and call icons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.chat_bubble_outline),
                                  label: const Text("Chat"),
                                ),
                                const SizedBox(width: 10),
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.call),
                                  label: const Text("Call"),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: AppColor.primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
