import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:depi_app/features/chat/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/chat_bubbles.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({super.key});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final _controller = ScrollController();
  final TextEditingController controller = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ChatCubit(ChatRepository())
                ..getMessages(currentUserId)
                ..markAsRead()
                ..repository.resetUserUnreadCount(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Iconsax.headphone_copy, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text("Customer Support"),
                ],
              ),
              backgroundColor: AppColors.accent, // أو لون البراند بتاعك
              foregroundColor: Colors.white,
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatError) {
                        return Center(child: Text("Error: ${state.message}"));
                      } else if (state is ChatLoaded) {
                        final messages = state.messages;

                        if (messages.isEmpty) {
                          return _buildEmptyState();
                        }

                        return ListView.builder(
                          reverse: true,
                          controller: _controller,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            final isMe = msg.senderId == currentUserId;
                            return ChatBubble(message: msg, isMe: isMe);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                _buildInputArea(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Iconsax.message_question_copy,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'How can we help you today?',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (data) => _sendMessage(context, data),
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(
                Iconsax.send_1_copy,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => _sendMessage(context, controller.text),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context, String text) {
    if (text.trim().isEmpty) return;
    context.read<ChatCubit>().sendMessage(text.trim());
    controller.clear();
    if (_controller.hasClients) {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
