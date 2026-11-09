import 'package:flutter/material.dart';
import 'package:wep/controller/Homecontroller.dart';
import 'package:wep/core/models/chatroommodel.dart';

class RoomTile extends StatelessWidget {
  final ChatRoom room;
  final RoomController controller;

  const RoomTile({required this.room, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: room.isPrivate
              ? Colors.amber[100]
              : Colors.blue[100],
          child: Icon(
            room.isPrivate ? Icons.lock : Icons.public,
            color: room.isPrivate ? Colors.amber[900] : Colors.blue[800],
          ),
        ),
        title: Text(
          room.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          room.isPrivate
              ? "Private • Password Required"
              : "Public • Anyone can join",
          style: TextStyle(
            color: room.isPrivate ? Colors.orange[800] : Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: room.isPrivate ? Colors.amber[800] : Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => controller.joinRoom(room),
          child: const Text("Join", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}