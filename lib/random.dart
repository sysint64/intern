import 'dart:math';
import 'dart:typed_data';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

int randomInt(int min, int max) => min + Random().nextInt(max - min);

String randomString(int length) {
  return String.fromCharCodes(
      Iterable.generate(length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));
}

Uint8List randomBytes(int length, {bool secure = false}) {
  assert(length > 0);

  final random = secure ? Random.secure() : Random();
  final ret = Uint8List(length);

  for (var i = 0; i < length; i++) {
    ret[i] = random.nextInt(256);
  }

  return ret;
}
