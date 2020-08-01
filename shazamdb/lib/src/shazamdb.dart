import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

class SDB {
  Map<String, List<double>> db;

  SDB(this.db);

  static int _readlen(List<int> b, int o) =>
      Uint8List.fromList(b).buffer.asByteData().getInt32(o, Endian.big);

  static Future<SDB> read(String file) async {
    var f = await File(file);
    await f.open();
    var b = ZLibDecoder(raw: true).convert(await f.readAsBytes());
    var i = 0;
    var m = <String, List<double>>{};
    while (i < b.length) {
      var len = _readlen(b, i);
      i += 4;
      var n = utf8.decode(b.sublist(i, i + len));
      i += len;
      len = _readlen(b, i);
      i += 4;
      var raw = Uint8List.fromList(b.sublist(i, i + len)).buffer.asByteData();
      i += len;
      var data = <double>[];
      for (var j = 0; i < len; j += 8) data[j] = raw.getFloat64(j, Endian.big);
      m[n] = m[data];
    }
    return SDB(m);
  }

  Future<Null> write(String file) async {
    var fulllen = 0;
    for (var key in db.keys) {
      fulllen += 8;
      fulllen += utf8.encode(key).length;
      fulllen += db[key].length * 8;
    }
    var b = Uint8List(fulllen).buffer.asByteData();
    var i = 0;
    for (var key in db.keys) {
      var val = db[key];
      b.setInt32(i, utf8.encode(key).length);
      i += 4;
      for (var byte in utf8.encode(key)) b.setUint8(i++, byte);
      b.setInt32(i, val.length * 8);
      i += 4;
      for (var d in val) b.setFloat64(i += 8, d, Endian.big);
    }
    var f = await File(file);
    await f.open(mode: FileMode.writeOnly);
    await f.writeAsBytes(ZLibEncoder(raw: true, level: 9, memLevel: 9)
        .convert(b.buffer.asUint8List()));
  }
}
