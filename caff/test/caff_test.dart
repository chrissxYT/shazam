import 'dart:io';

import 'package:caff/caff.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    CaffFile caf;
    setUp(() async {
      caf = await CaffFile.read('test.caf');
    });
    test('First Test', () {
      caf.decodeFrames();
    });
  });
}
