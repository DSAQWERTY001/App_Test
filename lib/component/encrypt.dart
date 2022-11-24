import 'package:encrypt/encrypt.dart';

class EncryptData {
  static Encrypted? encrypted;

  static String encryptAES(plainText) {
    final key = Key.fromUtf8('KMUTNBVOTINGSECRECTUNKNOWKMUTNB1');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted!.base16;
  }
}
