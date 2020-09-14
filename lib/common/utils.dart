import 'dart:math';

String getRandomString(int length) {
  final alNum =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  return String.fromCharCodes(
    Iterable.generate(
      length,
          (_) => alNum.codeUnitAt(Random().nextInt(alNum.length)),
    ),
  );
}