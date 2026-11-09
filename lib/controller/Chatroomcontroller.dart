import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wep/controller/usercontroller.dart';
import 'package:wep/core/models/chatroommodel.dart';
import 'package:wep/core/models/messagemodel.dart';

class ChatController extends GetxController {
  ChatRoom? room;

  final TextEditingController messageController = TextEditingController();
  RxList<MessageModel> messages = <MessageModel>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final userController = Get.find<UserController>();
  String get currentUserId => userController.currentUser.value?.uid ?? '';

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;
    final user = userController.currentUser.value;
    if (user == null) {
      Get.snackbar("خطأ", "لم يتم العثور على بيانات المستخدم");
      return;
    }

    final text = messageController.text.trim();
    messageController.clear();
    try {
      await _firestore
          .collection('rooms')
          .doc(room!.id)
          .collection('messages')
          .add({
            'senderId': user.uid,
            'senderName': user.username,
            'senderGender': user.gender,
            'text': text,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      Get.snackbar("خطأ", "فشل إرسال الرسالة: $e");
    }
  }

  Future<void> fetchRooms() async {
    try {
      messages.bindStream(
        _firestore
            .collection('rooms')
            .doc(room!.id)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .map(
              (snapshot) => snapshot.docs
                  .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
                  .toList(),
            ),
      );
    } catch (et) {
      Get.snackbar("خطأ", "فشل في جلب الغرف: $et");
    }
  }

  @override
  void onInit() {
    room = Get.arguments["room"];
    fetchRooms();
    super.onInit();
  }
}
