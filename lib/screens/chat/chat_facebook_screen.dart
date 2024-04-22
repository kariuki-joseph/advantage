import 'dart:async';
import 'dart:math';

import 'package:advantage/screens/home/controller/messages_controller.dart';
import 'package:advantage/themes/custom_chat_theme.dart';
import 'package:advantage/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChatFacebookScreen extends StatefulWidget {
  const ChatFacebookScreen({super.key});

  @override
  _ChatFacebookScreenState createState() => _ChatFacebookScreenState();
}

class _ChatFacebookScreenState extends State<ChatFacebookScreen> {
  TextEditingController? _chatTextController;
  CustomChatTheme customChatTheme = CustomChatTheme.getFacebookTheme();

  ScrollController? _scrollController;

  final List<String> _simpleChoice = ["Create shortcut", "Clear chat"];

  late CustomTheme customTheme;
  late ThemeData theme;

  final MessagesController messagesController = Get.find<MessagesController>();

  @override
  initState() {
    super.initState();
    // fetch conversations
    messagesController.fetchMessages();

    customTheme = CustomTheme.darkCustomTheme;
    _chatTextController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customChatTheme.appBarColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Material(
                color: Colors.transparent,
                // button color
                child: InkWell(
                  splashColor: Colors.white,
                  // inkwell color
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(
                      LucideIcons.arrowLeft,
                      color: customChatTheme.btnColor,
                      size: 24,
                    ),
                  ),
                  onTap: () {
                    messagesController.showChat.value = false;
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/user_avatar.png"),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Obx(
                      () => Text(
                        messagesController.receiverName.value,
                        style: Get.theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Text(
                      "",
                      style: TextStyle(
                          height: 1.2, color: theme.colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Icon(
            LucideIcons.phone,
            color: customChatTheme.btnColor,
          ),
          Container(
              margin: const EdgeInsets.only(left: 16),
              child: Icon(
                LucideIcons.video,
                color: customChatTheme.btnColor,
              )),
          PopupMenuButton(
            onSelected: (dynamic choice) {
              onSelectedMenu(choice);
            },
            itemBuilder: (BuildContext context) {
              return _simpleChoice.map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            color: theme.colorScheme.background,
            icon: Icon(
              LucideIcons.moreVertical,
              color: customChatTheme.btnColor,
            ),
          ),
        ],
      ),
      body: Container(
        color: customChatTheme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Center(
                    child: Text(
                      // "16 AUG 2020 AT 9:44 PM",
                      "",
                      style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Obx(
                    () => ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(0),
                      itemCount: messagesController.userMessages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: index == 0
                              ? const EdgeInsets.only(top: 8, bottom: 1).add(
                                  messagesController.userMessages[index].senderId.compareTo(messagesController.loggedInUser.id) == 0
                                      ? EdgeInsets.only(
                                          left:
                                              MediaQuery.of(context).size.width *
                                                  0.2)
                                      : EdgeInsets.only(
                                          right:
                                              MediaQuery.of(context).size.width *
                                                  0.2))
                              : const EdgeInsets.only(top: 1, bottom: 1).add(
                                  messagesController.userMessages[index].senderId.compareTo(messagesController.loggedInUser.id) == 0
                                      ? EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2)
                                      : EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2)),
                          alignment: messagesController
                                      .userMessages[index].senderId
                                      .compareTo(
                                          messagesController.loggedInUser.id) ==
                                  0
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: singleChat(index),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white,
                            child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Transform.rotate(
                                  angle: -pi / 4,
                                  child: Icon(
                                    LucideIcons.paperclip,
                                    size: 24,
                                    color: customChatTheme.btnColor,
                                  ),
                                )),
                            onTap: () {
                              addBottomSheet(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            color: customChatTheme.textFieldBackground,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(24.0),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  child: TextField(
                                    maxLines: 8,
                                    minLines: 1,
                                    style: theme.textTheme.bodyLarge!.merge(
                                        TextStyle(
                                            color: customChatTheme
                                                .textOnTextField)),
                                    decoration: InputDecoration(
                                      hintText: "Type a message...",
                                      isDense: true,
                                      hintStyle: theme.textTheme.titleMedium!
                                          .merge(TextStyle(
                                              color: customChatTheme
                                                  .textOnTextField!
                                                  .withAlpha(220))),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                    controller: _chatTextController,
                                    onSubmitted: (String text) =>
                                        sendMessage(text),
                                  ),
                                ),
                              ),
                              ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  // button color
                                  child: InkWell(
                                    splashColor: Colors.white,
                                    // inkwell color
                                    child: SizedBox(
                                        width: 44,
                                        height: 44,
                                        child: Icon(
                                          LucideIcons.smile,
                                          size: 24,
                                          color: customChatTheme.btnColor,
                                        )),
                                    onTap: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.white,
                                // inkwell color
                                child: SizedBox(
                                  width: 42,
                                  height: 42,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      LucideIcons.send,
                                      size: 22,
                                      color: customChatTheme.btnColor,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  sendMessage(_chatTextController!.text);
                                },
                              ),
                            ),
                          ))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget singleChat(int index) {
    if (messagesController.userMessages[index].senderId
            .compareTo(messagesController.loggedInUser.id) ==
        0) {
      return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: customChatTheme.myChatBG,
            borderRadius: makeChatBubble(index),
          ),
          child: Text(messagesController.userMessages[index].message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: customChatTheme.onMyChat,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.fade,
                  )));
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 4, right: 8),
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("./assets/images/profile/avatar_2.jpg"),
                    fit: BoxFit.fill),
                shape: BoxShape.circle,
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: customChatTheme.chatBG,
                  borderRadius: makeChatBubble(index),
                ),
                child: Text(
                  messagesController.userMessages[index].message,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      overflow: TextOverflow.fade,
                      color: customChatTheme.onChat),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  String getStringTimeFromMilliseconds(String timestamp) {
    try {
      int time = int.parse(timestamp);
      var date = DateTime.fromMillisecondsSinceEpoch(time);
      int hour = date.hour, min = date.minute;
      if (hour > 12) {
        if (min < 10) {
          return "${hour - 12}:0$min pm";
        } else {
          return "${hour - 12}:$min pm";
        }
      } else {
        if (min < 10) {
          return "$hour:0$min am";
        } else {
          return "$hour:$min am";
        }
      }
    } catch (e) {
      return "";
    }
  }

  BorderRadius makeChatBubble(int index) {
    if (messagesController.userMessages[index].senderId
            .compareTo(messagesController.loggedInUser.id) ==
        0) {
      if (index != 0) {
        if (messagesController.userMessages[index - 1].senderId
                .compareTo(messagesController.loggedInUser.id) ==
            0) {
          return const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              topRight: Radius.circular(12));
        } else {
          return const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(12),
              topRight: Radius.circular(12));
        }
      } else {
        return const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(4),
            bottomLeft: Radius.circular(12),
            topRight: Radius.circular(12));
      }
    } else {
      if (index != 0) {
        if (messagesController.userMessages[index - 1].senderId
                .compareTo(messagesController.loggedInUser.id) !=
            0) {
          return const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              topRight: Radius.circular(12));
        } else {
          return const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(12));
        }
      } else {
        return const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(4),
            topRight: Radius.circular(12));
      }
    }
  }

  void onSelectedMenu(choice) {
    if (choice.toString().compareTo(_simpleChoice[0]) == 0) {
    } else if (choice.toString().compareTo(_simpleChoice[1]) == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return deleteAllChatDialog();
          });
    } else {}
  }

  Widget deleteAllChatDialog() {
    return Dialog(
      backgroundColor: customChatTheme.backgroundColor,
      child: Container(
        padding: const EdgeInsets.only(top: 24, bottom: 0, left: 24, right: 0),
        decoration: BoxDecoration(
          color: customChatTheme.backgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 24),
              child: Text(
                "Are you sure to clear messages in this chat",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: customChatTheme.onBackground,
                    ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 8),
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel".toUpperCase(),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "clear".toUpperCase(),
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      messagesController.sendMessage(message);
      _chatTextController!.clear();
    }
  }

  scrollToBottom({bool isDelayed = false}) {
    final int delay = isDelayed ? 400 : 0;
    Future.delayed(Duration(milliseconds: delay), () {
      _scrollController!.animateTo(_scrollController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  void addBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            margin: const EdgeInsets.only(bottom: 64, left: 16, right: 16),
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0))),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  quickActionWidget(
                                    LucideIcons.clipboardList,
                                    'Document',
                                  ),
                                  quickActionWidget(
                                    LucideIcons.music2,
                                    'Audio',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  quickActionWidget(
                                    LucideIcons.camera,
                                    'Camera',
                                  ),
                                  quickActionWidget(
                                    LucideIcons.mapPin,
                                    'Location',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  quickActionWidget(
                                    LucideIcons.image,
                                    'Gallery',
                                  ),
                                  quickActionWidget(
                                    LucideIcons.userSquare2,
                                    'Contact',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget quickActionWidget(IconData iconData, String actionText) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: <Widget>[
          ClipOval(
            child: Material(
              color: customChatTheme.btnColor, // button color
              child: InkWell(
                splashColor: Colors.white,
                // inkwell color
                child: SizedBox(
                    width: 52,
                    height: 52,
                    child: Icon(
                      iconData,
                      color: customChatTheme.iconOnBtn,
                      size: 25,
                    )),
                onTap: () {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              actionText,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
