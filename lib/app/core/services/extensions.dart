import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;


extension ToJsonString on Map<String, dynamic> {
  String toJsonRequest() {
    return jsonEncode(this);
  }
}


extension EncriptString on String {
  String encript() {
    const key =
        "&F)J@NcRfUjXn2r5u7x!A%D*G-KaPdSg";
    encrypt.Encrypted encrypted = encryptWithAES(key, this);
    return encrypted.base64;
  }
}

extension EecryptString on String {
  String decrypt() {
    const key =
        "&F)J@NcRfUjXn2r5u7x!A%D*G-KaPdSg";
    //Decrypt
    return decryptWithAES(key, this);
  }
}

///Accepts encrypted data and decrypt it. Returns plain text
String decryptWithAES(String key, String encryptedData) {
  final cipherKey = encrypt.Key.fromUtf8(key.substring(0, 32));
  final encryptService = encrypt.Encrypter(
    encrypt.AES(cipherKey, mode: encrypt.AESMode.cbc),
  ); //Using AES CBC encryption
  final initVector = encrypt.IV.fromUtf8(key.substring(0, 16));

  return encryptService.decrypt64(encryptedData, iv: initVector);
}

///Encrypts the given plainText using the key. Returns encrypted data
encrypt.Encrypted encryptWithAES(String key, String plainText) {
  final cipherKey = encrypt.Key.fromUtf8(key.substring(0, 32));
  final encryptService = encrypt.Encrypter(
    encrypt.AES(cipherKey, mode: encrypt.AESMode.cbc),
  );
  final initVector = encrypt.IV.fromUtf8(
    key.substring(0, 16),
  );
  final encryptedData = encryptService.encrypt(
    plainText,
    iv: initVector,
  );
  return encryptedData;
}
 

// Future<void> navigateToLogin() async {
//   navigatorKey.currentState?.pushNamedAndRemoveUntil(
//     '/login', // or whatever your login route is
//     (route) => false,
//   );
// }
