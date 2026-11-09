import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wep/core/models/chatroommodel.dart';
import 'package:wep/core/services/firestoreservices.dart';
import 'package:wep/view/screen/chatroomscreen.dart';

class RoomController extends GetxController {
  final firestore = FirestoreServices.instance;
  late TextEditingController title;
  late TextEditingController password;
  final RxBool isPrivate = false.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxList<ChatRoom> rooms = <ChatRoom>[].obs;

  void fetchRooms() {
    rooms.bindStream(
      firestore
          .getdata("rooms")
          .map((rawData) => rawData.map((e) => ChatRoom.fromJson(e)).toList()),
    );
  }

  // دالة الدخول للغرفة
  void joinRoom(ChatRoom room) {
    if (!room.isPrivate) {
      _navigateToChat(room);
    } else {
      _showPasswordDialog(room);
    }
  }

  Map<String, dynamic> get data => {
    "id": "",
    "name": title.text,
    "isPrivate": isPrivate.value,
    "password": password.text,
  };

  //Create room =================================
  Future<void> creatcnewchatroom() async {
    if (formKey.currentState!.validate()) {
      try {
        await firestore.postdata("rooms", data);
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
        fetchRooms();
        Get.to(
          () => ChatRoomScreen(),
          arguments: {"room": rooms.where((r) => r.name == title.text).first},
        );

        Get.snackbar(
          "تم بنجاح",
          "تم إنشاء الغرفة بنجاح",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        Get.snackbar(
          "خطأ",
          "حدث خطأ أثناء إنشاء الغرفة: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  // نافذة إدخال كلمة السر للغرف الخاصة
  void _showPasswordDialog(ChatRoom room) {
    final TextEditingController passController = TextEditingController();

    Get.defaultDialog(
      title: "Private Room",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("This room is password protected."),
            const SizedBox(height: 12),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Enter Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      textConfirm: "Join",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.deepOrange,
      onConfirm: () {
        if (passController.text.trim() == room.password) {
          Get.back(); // إغلاق النافذة
          _navigateToChat(room);
        } else {
          Get.snackbar(
            "Access Denied",
            "Incorrect password!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
    );
  }

  void _navigateToChat(ChatRoom room) {
    Get.to(() => ChatRoomScreen(), arguments: {"room": room});
  }

  @override
  void onInit() {
    fetchRooms();
    super.onInit();
  }
}
