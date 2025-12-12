import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db;
  ChatService({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _messagesRef(String chatId) {
    return _db.collection('chats').doc(chatId).collection('messages');
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> messagesStream(String chatId) {
    return _messagesRef(chatId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs);
  }

  Future<String> addMessage(
    String chatId, {
    required String text,
    required String sender,
    String? senderId,
  }) async {
    final doc = await _messagesRef(chatId).add({
      'text': text,
      'sender': sender,
      'senderId': senderId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> listChatUsers() async {
    final snap = await _db.collection('chats').get();
    return snap.docs;
  }
}
