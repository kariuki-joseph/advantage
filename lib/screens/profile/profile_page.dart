import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:advantage/screens/home/controller/my_ads_controller.dart';
import 'package:advantage/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late CustomTheme customTheme;
  late ThemeData theme;
  final AuthController authController = Get.find<AuthController>();
  final MyAdsController myAdsController = Get.put(MyAdsController());

  @override
  initState() {
    super.initState();
    customTheme = CustomTheme.darkCustomTheme;
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Center(
            child: Text(
              "My Profile",
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 70),
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: customTheme.groceryPrimary.withAlpha(40),
                ),
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'images/user_avatar.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                authController.user.value.username,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 32),
            // show user their login credentials
            getSingleSetting(
              iconData: LucideIcons.phone,
              color: CustomTheme.purple,
              title: authController.user.value.phone,
            ),
            getSingleSetting(
                iconData: LucideIcons.mail,
                color: CustomTheme.orange,
                title: authController.user.value.email),
            // my ads count
            Obx(
              () => getSingleSetting(
                iconData: LucideIcons.calendar,
                color: CustomTheme.green,
                title: "My Ads: ${myAdsController.myAds.length}",
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                authController.logout();
              },
              child: getSingleSetting(
                iconData: LucideIcons.logOut,
                color: CustomTheme.red,
                title: "Log Out",
              ),
            ),
          ],
        ));
  }

  Widget getSingleSetting(
      {IconData? iconData, required Color color, required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withAlpha(24),
            ),
            child: Icon(
              iconData,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 24),
          Text(
            title,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
