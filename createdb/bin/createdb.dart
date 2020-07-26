import 'package:caff/caff.dart';

import 'dart:io';

double avg(List<double> l) {
  // ignore: omit_local_variable_types
  double d = 0;
  for (var e in l) d += e;
  return d / l.length;
}

List<double> mono(List<double> frames, int channels) {
  var l = <double>[];
  for (var i = 0; i < frames.length; i += channels)
    l.add(avg(frames.sublist(i, i + channels)));
  return l;
}

void main(List<String> argv) async {
  if (argv.length < 2) {
    print('not enough args');
    print('give me: [output db] [input 1] [input 2] {...}');
    exit(1);
  }
  for (var file in argv.sublist(1)) {
    var caf = await CaffFile.read(file);
    var frames = caf.decodeFrames();
    if (caf.channels > 1) frames = mono(frames, caf.channels);
  }
}
