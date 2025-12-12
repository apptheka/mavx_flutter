import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/chat/chat_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Disable Hero animations on this page to avoid duplicate hero tag conflicts
    return HeroMode(
      enabled: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final items = controller.messages;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final m = items[index];
                  final align = m.from == MsgFrom.me ? Alignment.centerRight : Alignment.centerLeft;
                  final bubbleColor = m.from == MsgFrom.me ? AppColors.primaryColor : const Color(0xFFF2F3F7);
                  final textColor = m.from == MsgFrom.me ? Colors.white : Colors.black87;
                  return Align(
                    alignment: align,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(m.text, style: TextStyle(color: textColor)),
                    ),
                  );
                },
              );
            }),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.inputController,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => controller.send(),
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: controller.send,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
        ),
      ),
    );
  }
}
