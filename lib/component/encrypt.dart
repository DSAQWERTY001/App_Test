import 'package:encrypt/encrypt.dart';

class EncryptData {
  static Encrypted? encrypted;

  static dynamic encryptAES(plainText) {
    final key = Key.fromUtf8('KMUTNBVOTINGSECRECTUNKNOWKMUTNB1');
    final iv = IV.fromBase16("0000000000000000");
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base16;
  }
}
