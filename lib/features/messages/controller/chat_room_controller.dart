import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_management/features/messages/api/chat_room_api.dart';
import 'package:hr_management/features/messages/model/chat_room_model.dart';

class ChatRoomController extends GetxController {
  var chatRooms = <ChatRoomModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatRooms();
  }

// Api call to get chat rooms
  Future<void> fetchChatRooms() async {
    try {
      isLoading(true);
      final response = await ChatRoomApi.fetchChatRoom();
      if (response.success) {
        chatRooms.assignAll(response.data);
      } else {
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch chat rooms: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading(false);
    }
  }

  List<ChatRoomModel> get groupRooms =>
      chatRooms.where((room) => room.isGroup).toList();
  List<ChatRoomModel> get privateRooms =>
      chatRooms.where((room) => room.isPrivate).toList();

// Api call to create/post a chat room
  Future<String?> startPrivateChat(String name, String userId) async {
    try {
      final roomId = await ChatRoomApi.createChatRoom(name, 'PRIVATE', 'Private conversation with $name');
      if (roomId.isNotEmpty) {
        await ChatRoomApi.postChatMembers(roomId, userId);
      }
      await fetchChatRooms();
      return roomId;
    } catch(e) {
      Get.snackbar('Error', 'Failed to start conversation', backgroundColor: Colors.red.withValues(alpha: 0.1));
      return null;
    }
  }

// Api call to create chat room
  Future<bool> createGroupChat(String name, String desc, String type) async {
    try {
      await ChatRoomApi.createChatRoom(name, type, desc);
      await fetchChatRooms();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create chat room', backgroundColor: Colors.red.withValues(alpha: 0.1));
      return false;
    }
  }

// Api call to post/add new member
  Future<bool> addMemberToChat(String roomId, String userId, {String? firstName, String? email}) async {
    try {
      await ChatRoomApi.postChatMembers(roomId, userId);
      
      // Update local reactive list immediately
      final index = chatRooms.indexWhere((r) => r.id == roomId);
      if (index != -1) {
        final room = chatRooms[index];
        final updatedParticipantIds = List<String>.from(room.participantIds ?? [])..add(userId);
        
        final updatedRawMembers = List<Map<String, dynamic>>.from(room.rawMembers ?? [])..add({
          'userId': userId,
          'role': 'MEMBER',
          'user': {
              'id': userId,
              'firstName': firstName,
              'email': email,
          }
        });
        
        final updatedRoom = ChatRoomModel(
            id: room.id,
            name: room.name,
            type: room.type,
            createdBy: room.createdBy,
            createdAt: room.createdAt,
            updatedAt: room.updatedAt,
            participantIds: updatedParticipantIds,
            rawMembers: updatedRawMembers,
            lastMessageAt: room.lastMessageAt,
            unreadCount: room.unreadCount,
        );
        
        chatRooms[index] = updatedRoom;
        // Fire a background fetch just to ensure sync, but UI updates instantly
        fetchChatRooms();
      }
      
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add member', backgroundColor: Colors.red.withValues(alpha: 0.1));
      return false;
    }
  }
}
