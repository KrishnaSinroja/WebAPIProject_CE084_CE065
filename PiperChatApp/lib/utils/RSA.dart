import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;

class RSA {
  var helper = RsaKeyHelper();

  //Future to hold our KeyPair
  Future<crypto.AsymmetricKeyPair> futureKeyPair;

  //to store the KeyPair once we get data from our future
  crypto.AsymmetricKeyPair keyPair;

  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      getKeyPair() {
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  static String publicKeyString(crypto.PublicKey publicKey) {
    return new RsaKeyHelper().encodePublicKeyToPemPKCS1(publicKey);
  }

  static String privateKeyString(crypto.PrivateKey privateKey) {
    return new RsaKeyHelper().encodePrivateKeyToPemPKCS1(privateKey);
  }

  static crypto.PrivateKey getPrivateKey(String privateKey) {
    return new RsaKeyHelper().parsePrivateKeyFromPem(privateKey);
  }

  static crypto.PublicKey getPublicKey(String publicKey) {
    return new RsaKeyHelper().parsePublicKeyFromPem(publicKey);
  }

  static String encrypt(String plaintext, RSAPublicKey publicKey) {
    var cipher = new RSAEngine()
      ..init(true, new PublicKeyParameter<RSAPublicKey>(publicKey));
    var cipherText =
        cipher.process(new Uint8List.fromList(plaintext.codeUnits));

    return new String.fromCharCodes(cipherText);
  }

  /// Decrypting String
  static String decrypt(String ciphertext, RSAPrivateKey privateKey) {
    var cipher = new RSAEngine()
      ..init(false, new PrivateKeyParameter<RSAPrivateKey>(privateKey));
    var decrypted =
        cipher.process(new Uint8List.fromList(ciphertext.codeUnits));

    return new String.fromCharCodes(decrypted);
  }
}
