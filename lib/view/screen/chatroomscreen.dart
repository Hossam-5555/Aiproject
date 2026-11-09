import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wep/controller/Chatroomcontroller.dart';
import 'package:wep/controller/authcontroller.dart';
import 'package:wep/core/conistant/imageaasset.dart'; 
import 'package:wep/view/widget/chatBubble.dart'; 

class ChatRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    Get.lazyPut(() => AuthController());
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: controller.room!.isPrivate
                  ? Colors.amber[800]
                  : Colors.blue[800],
              child: Icon(
                controller.room!.isPrivate ? Icons.lock : Icons.public,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.room!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  controller.room!.isPrivate ? "Private Room" : "Public Room",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                image: DecorationImage(
                  image: AssetImage(Imageaasset.backgroundimage),
                  fit: BoxFit.cover,
                  opacity: 0.08,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.messages.isEmpty) {
                      return const Center(
                        child: Text(
                          "لا توجد رسائل بعد.. ابدأ المحادثة!",
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    }

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];
                        final isMe =
                            message.senderId == controller.currentUserId;

                        return ChatBubble(message: message, isMe: isMe);
                      },
                    );
                  }),
                ),

                _buildMessageInputField(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت حقل الكتابة والزِر
  Widget _buildMessageInputField(ChatController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFF1E293B),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "اكتب رسالة...",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 22,
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => controller.sendMessage(),
            ),
          ),
        ],
      ),
    );
  }
}
