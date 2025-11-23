import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

import 'package:path_provider/path_provider.dart';

Future<dynamic> takePicture({
  required GlobalKey contentKey,
  required BuildContext context,
  required bool saveToGallery,
}) async {
  try {
    final boundary =
    contentKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    final image = await boundary?.toImage(pixelRatio: 3.0);

    final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();
    final compressedBytes = await compressByte(pngBytes);

    final dir = (await getApplicationDocumentsDirectory()).path;
    final imagePath = '$dir/${DateTime.now()}.png';
    final capturedFile = File(imagePath);
    await capturedFile.writeAsBytes(compressedBytes!);

    if (saveToGallery) {
      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes!,
        quality: 100,
        name: '${DateTime.now()}.png',
      );
      if (result != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return imagePath;
    }
  } catch (e) {
    return false;
  }
}

Future<Uint8List?> compressByte(Uint8List? file) async {
  if (file == null) return null;
  if (file.lengthInBytes > 200000) {
    final result = await FlutterImageCompress.compressWithList(
      file,
      quality: file.lengthInBytes > 4000000 ? 90 : 72,
    );
    return result;
  } else {
    return file;
  }
}