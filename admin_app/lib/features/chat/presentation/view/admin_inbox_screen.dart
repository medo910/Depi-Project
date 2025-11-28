import 'package:admin_app/features/chat/presentation/cubits/admin_chat_cubit/admin_chat_cubit.dart';
import 'package:admin_app/features/chat/presentation/view/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdminInboxScreen extends StatefulWidget {
  const AdminInboxScreen({super.key});

  @override
  State<AdminInboxScreen> createState() => _AdminInboxScreenState();
}

class _AdminInboxScreenState extends State<AdminInboxScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminChatCubit>().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Support'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Iconsax.search_normal_1_copy),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                context.read<AdminChatCubit>().getUsers(query: query);
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<AdminChatCubit, AdminChatState>(
        builder: (context, state) {
          if (state is AdminChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminChatError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is AdminChatLoaded) {
            final users = state.users;
            if (users.isEmpty) {
              return const Center(child: Text('No users found.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AdminChatCubit>().getUsers();
              },
              child: ListView.separated(
                itemCount: users.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = users[index];
                  final bool hasChat = user['hasChat'] ?? false;
                  final int unread = user['unreadCount'] ?? 0;
                  final Timestamp? time = user['lastMessageTime'];

                  final String lastMsg = user['lastMessage'] ?? '';
                  final String lastSenderId = user['lastSenderId'] ?? '';
                  final String userName = user['name'] ?? 'Unknown';

                  String subtitleText = 'Start a conversation';
                  if (hasChat) {
                    if (lastSenderId == 'admin') {
                      subtitleText = 'You: $lastMsg';
                    } else {
                      subtitleText = '$userName: $lastMsg';
                    }
                  }
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          user['photoUrl'] != null
                              ? CachedNetworkImageProvider(user['photoUrl'])
                              : null,
                      child:
                          user['photoUrl'] == null
                              ? Text((user['name'] ?? 'U')[0].toUpperCase())
                              : null,
                    ),
                    title: Text(
                      user['name'] ?? 'Unknown',
                      style: TextStyle(
                        fontWeight:
                            unread > 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      subtitleText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            hasChat
                                ? Colors.grey[700]
                                : Theme.of(context).primaryColor,
                        fontWeight:
                            unread > 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (time != null)
                          Text(
                            DateFormat('hh:mm a').format(time.toDate()),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        if (unread > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$unread',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ChatScreen(
                                chatId: user['uid'],
                                otherUserName: user['name'] ?? 'User',
                                isAdmin: true,
                              ),
                        ),
                      );
                      if (context.mounted) {
                        context.read<AdminChatCubit>().getUsers();
                      }
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
