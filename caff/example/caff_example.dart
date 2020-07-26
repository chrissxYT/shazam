import 'package:caff/caff.dart';

void main() async {
  var caf = await CaffFile.read('example.caf');
  var frames = caf.decodeFrames();
}
