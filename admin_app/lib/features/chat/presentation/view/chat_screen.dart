import 'package:admin_app/core/theme/app_colors.dart';
import 'package:admin_app/features/chat/data/repositories/chat_repository.dart';
import 'package:admin_app/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:admin_app/features/chat/presentation/view/widgets/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ChatScreen extends StatefulWidget {
  static String id = "Chat Page";
  final String chatId;
  final String otherUserName;
  final bool isAdmin;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserName,
    required this.isAdmin,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = ScrollController();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        widget.isAdmin ? 'admin' : FirebaseAuth.instance.currentUser!.uid;

    final String friendId = widget.chatId;

<<<<<<< HEAD
=======
    final size = MediaQuery.sizeOf(context);

>>>>>>> temp-fix
    return BlocProvider(
      create:
          (context) =>
              ChatCubit(context.read<ChatRepository>())
                ..getMessages(friendId)
                ..markMessagesAsRead(friendId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.darkPrimary,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Row(
                children: [
                  CircleAvatar(
<<<<<<< HEAD
=======
                    radius: size.width * 0.05,
>>>>>>> temp-fix
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      widget.otherUserName.isNotEmpty
                          ? widget.otherUserName[0].toUpperCase()
                          : 'U',
<<<<<<< HEAD
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.otherUserName,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
=======
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Text(
                    widget.otherUserName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.045,
                    ),
>>>>>>> temp-fix
                  ),
                ],
              ),
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
                        final messagesList = state.messages;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_controller.hasClients) {
                            _controller.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });

                        return ListView.builder(
                          reverse: true,
                          controller: _controller,
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            final msg = messagesList[index];
                            final isMe = msg.senderId == currentUserId;
                            return ChatBubble(message: msg, isMe: isMe);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                Padding(
<<<<<<< HEAD
                  padding: const EdgeInsets.all(16.0),
=======
                  padding: EdgeInsets.all(size.width * 0.04),
>>>>>>> temp-fix
                  child: TextField(
                    controller: controller,
                    onSubmitted:
                        (data) => _sendMessage(context, data, currentUserId),
<<<<<<< HEAD
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Iconsax.send_1_copy,
                          color: AppColors.darkPrimary,
=======
                    style: TextStyle(fontSize: size.width * 0.04),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.015,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Iconsax.send_1_copy,
                          color: AppColors.darkPrimary,
                          size: size.width * 0.06,
>>>>>>> temp-fix
                        ),
                        onPressed:
                            () => _sendMessage(
                              context,
                              controller.text,
                              currentUserId,
                            ),
                      ),
                      hintText: "Type your message...",
<<<<<<< HEAD
=======
                      hintStyle: TextStyle(fontSize: size.width * 0.035),
>>>>>>> temp-fix
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _sendMessage(BuildContext context, String text, String currentUserId) {
    if (text.trim().isEmpty) return;

    context.read<ChatCubit>().sendMessage(
      userId: widget.chatId,
      message: text.trim(),
      isAdmin: widget.isAdmin,
    );

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
