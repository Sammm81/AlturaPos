import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class EncryptionService {
  static const String _keyString = 'altura_pos_encryption_key_32b';
  
  late final encrypt_lib.Key _key;
  late final encrypt_lib.IV _iv;
  late final encrypt_lib.Encrypter _encrypter;

  EncryptionService() {
    _key = encrypt_lib.Key.fromUtf8(_keyString.padRight(32, '0').substring(0, 32));
    _iv = encrypt_lib.IV.fromLength(16);
    _encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(_key));
  }

  String encrypt(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decrypt(String encryptedText) {
    final encrypted = encrypt_lib.Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool verifyPassword(String password, String hashedPassword) {
    return hashPassword(password) == hashedPassword;
  }
}
