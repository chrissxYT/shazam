import 'dart:io';
import 'dart:typed_data';

class CaffFile {
  final int _channels;
  int get channels => _channels;
  final int _sampleWidth;
  int get sampleWidth => _sampleWidth;
  final int _framerate;
  int get framerate => _framerate;
  final ByteData _data;
  ByteData get data => _data;

  CaffFile(this._channels, this._sampleWidth, this._framerate, this._data);

  List<double> decodeFrames([double Function(int) convert]) {
    if (![1, 2, 4].contains(sampleWidth)) throw 'Unknown sample width.';
    convert ??= sampleWidth == 1
        ? (i) => data.getInt8(i).toDouble()
        : sampleWidth == 2
            ? (i) => data.getInt16(i, Endian.big).toDouble()
            : (i) => data.getFloat32(i, Endian.big);
    var l = <double>[];
    for (var i = 0; i < data.lengthInBytes; i += sampleWidth) l.add(convert(i));
    return l;
  }

  static Future<CaffFile> read(String file) async {
    var f = await File(file).open();
    var header = (await f.read(4 * 5)).buffer.asByteData();
    var c = CaffFile(
      header.getInt32(4, Endian.big),
      header.getInt32(8, Endian.big),
      header.getInt32(12, Endian.big),
      ByteData(
          header.getInt32(16, Endian.big) * header.getInt32(8, Endian.big)),
    );
    await f.readInto(c.data.buffer.asUint8List());
    await f.close();
    return c;
  }
}
