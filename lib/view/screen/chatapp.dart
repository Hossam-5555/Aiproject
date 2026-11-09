import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wep/controller/Homecontroller.dart';
import 'package:wep/controller/usercontroller.dart';
import 'package:wep/core/conistant/imageaasset.dart';
import 'package:wep/view/screen/addtask.dart';
import 'package:wep/view/widget/RoomTile.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final c = Get.find<UserController>();
  final RoomController roomController = Get.put(RoomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            showCreateRoomBottomSheet(context, roomController);
          },
          label: const Text(
            "Create Room",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Chat Rooms",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PopupMenuButton(
                          child: Icon(Icons.more_vert, color: Colors.white),
                          itemBuilder: (e) => [
                            CheckedPopupMenuItem(
                              child: Text("Logout"),
                              onTap: () {
                                c.logout();
                              },
                            ),
                            CheckedPopupMenuItem(child: Text("Settengs")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: Obx(() {
                    if (roomController.rooms.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Rooms Available",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 8,
                        bottom: 80,
                      ),
                      itemCount: roomController.rooms.length,
                      itemBuilder: (context, index) {
                        final room = roomController.rooms[index];
                        return RoomTile(room: room, controller: roomController);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
